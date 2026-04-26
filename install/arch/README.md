> [!NOTE]
> This document references the [Arch Install Guide](https://codeberg.org/unixchad/arch-install-guide).

# Partition
- LVM on LUKS
- Hibernation to encrypted swap partition

The partition structure is designed as follows:

```
NAME            TYPE    MOUNTPOINTS
disk            disk
├─disk-p1       part    /boot
├─disk-p2       part
│ └─cryptlvm    crypt
│   ├─vg0-swap  lvm     [SWAP]
│   └─vg0-root  lvm     /root
└─disk-p3       part
  └─crypthome   crypt   /home
```

## Use `fdisk` to create the partions
```bash
# Replace `disk` with your actual hard disk name
fdisk /dev/disk
```

Run the following commands **INSIDE** `fdisk`

```bash
# Create a new `GPT` disklabel since we're booting the system with UEFI
g

# Create a new partition with `1G` size which is for bootloader
n -> (default) -> (default) -> +1G
# Change the above partition (it's 1 by default) to `EFI system`
t -> 1 -> 1

# Create the second partition for the LVM which includes swap and root
# Usually, n = memory size + root size
n -> (default) -> (default) -> +nG

# Create the third partition with the rest of storage
n -> (default) -> (default) -> (default)

# Save the partition table
w
```


## Configure the partions table

### LVM partions with `luks` encrypted

```bash
# Format the LVM partions with `luks`
cryptsetup luksFormat /dev/disk-p2
cryptsetup luksFormat /dev/disk-p3

# Decrypt them
cryptsetup open /dev/disk-p2 cryptlvm
cryptsetup open /dev/disk-p3 crypthome
```

### Setup Logical Volumes

```bash
# Create Physical Volume (PV)
pvcreate /dev/mapper/cryptlvm

# Create Volume Group (VG)
vgcreate vg0 /dev/mapper/cryptlvm

# Create Logical Volumes (LV) with size
# Usually, n is your memory size
lvcreate -L nG -n swap vg0
lvcreate -l 100%FREE -n root vg0
```

### Setup partions formats
```bash
# Format the first partion with `FAT32`
mkfs.fat -F32 /dev/disk-p1

# Format root volume group with `EXT4`
mkfs.ext4 /dev/vg0/root

# Format the third partion with `EXT4`
mkfs.ext4 /ev/mapper/crypthome

# Format swap volume group as SWAP partition
mkswap /dev/vg0/swap

```

### Mount partions to paths
```bash
mount /dev/vg0/root /mnt

# Create necessary mountpoints
mkdir -p /mnt/{boot,home}

mount /dev/disk-p1 /mnt/boot
mount /dev/mapper/crypthome /mnt/home

# Enable swap partion
swapon /dev/vg0/swap
```


# Installation OS and linux kernel
```bash
# config pacman
# config pacman
sed -i '/^#Color$/s/#//' /etc/pacman.conf
sed -i '/^#ParallelDownloads = 5/s/#//' /etc/pacman.conf

# change mirrorlist priority
reflector --save /etc/pacman.d/mirrorlist

# update keyring
pacman -Sy && pacman -S archlinux-keyring
# When you use an Arch Linux ISO that was released months ago, the included
# keyring may be outdated. The Arch Linux keyring contains the public keys used
# to verify the signatures of packages.

# install packages
pacstrap -K /mnt base base-devel linux linux-headers linux-firmware intel-ucode lvm2 vim neovim networkmanager man-db man-pages bash-completion

# explaining packages
#    base               minimal package set to define a basic arch linux
#                       installation
#    base-devel         basic tools to build arch linux packages
#    linux              the kernel
#    intel-ucode        ucode for intel cpu, amd cpu install `amd-ucode`
#    lvm2               if this package is not installed, root filesystem on the
#                       logical volume won't be able to be used
#    man-db             database for `man`
#    bash-completion    completion for sub-commands
```

## Save the file system tabs
```bash
genfstab -U /mnt >> /mnt/etc/fstab
```

## Configure the new system
before everything, `chroot` into the new system
```bash
arch-chroot /mnt
```

Set timezone and sync date/time
```bash
# Make a symbolic link to a timezone
ln -sf /usr/share/zoneinfo/{region}/{city} /etc/localtime

# Sync system time to hardware clock
hwclock --systohc
```

Configure locale
```bash
# Uncomment the `en_US.UTF-8`
sed -i '/^#en_US.UTF-8/s/^#//' /etc/locale.gen

# Generate locales
locale-gen

# Append to the locale.conf
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
```

Set `hostname` and local domains
```bash
hostname="{hostname}"
echo "$hostname" > /etc/hostname

# Append to hosts
echo -e "127.0.0.1\t${hostname}.localdomain ${hostname}" >> /etc/hosts
```

## Configure key file to decrypt luks container
```bash
cd /root

# Generate a key file with random 4096 bytes
dd if=/dev/urandom of=/root/cryptkey bs=1024 count=4

# Readonly
chmod 400 /root/cryptkey
# Immutable
chattr +i /root/cryptkey

cryptsetup luksAddKey /dev/disk-p3 /root/cryptkey
```

Save the crypt tabs
```bash
# Get UUIDs
echo '#'$(blkid | grep 'disk-p3') >> /etc/crypttab
```

Edit `/etc/crypttab`
```
#<mapper name>  UUID=<uuid> <password>      <options>
crypthome       UUID=<uuid> /root/cryptkey  luks,discard
```

## Create initial ramdisk environment
This guide is switching to systemd-based initramfs, for more details see the [hook list](https://wiki.archlinux.org/title/Mkinitcpio#Hook_list).

Edit hooks in `/etc/mkinitcpio.conf`, note that the hooks order does matter.

```
HOOKS=(base systemd autodetect microcode modconf kms keyboard sd-vconsole block sd-encrypt lvm2 filesystems fsck)
```

Then build initramfs image(s) according to all presets.
```bash
# create a dummy vconsole.conf to avoid mknitcpio errors if needed
touch /etc/vconsole.conf
mkinitcpio -P
```

## Configure root and new user
```bash
# Create the password for root user
passwd

# Create new user
# -G - add it into the `wheel` group
# -m - create home directory if not exist
useradd -G wheel -m {username}
passwd {username}

# Enable `sudo` for users from `wheel` group
visudo
```

Apply the following changes
```diff
-#%wheel ALL=(ALL:ALL) ALL
+%wheel ALL=(ALL:ALL) ALL
```

# Install and configure `systemd-boot`
```bash
# Install systemd-boot to `/boot`
bootctl install
```

Edit `/boot/loader/loader.conf`
```
default arch.conf
timeout 3
console-mode 0
```

## Create the boot entry
```bash
# UUID of the encrypted physical volume
echo '#'$(blkid | grep 'disk-p2') > /boot/loader/entries/arch.conf
# UUID of the logical volume of root
echo '#'$(blkid | grep 'vg0-root') >> /boot/loader/entries/arch.conf
```

Edit `/boot/loader/entries/arch.conf`, replace UUID with the actual ones.
```conf
title Arch Linux
linux /vmlinuz-linux
initrd /initramfs-linux.img
options rd.luks.name=<uuid>=cryptlvm root=UUID=<uuid>
```

- `uuid` in `rd.luks.name=<uuid>=cryptlvm` is the UUID of the encrypted physical volume. Omit it if it's not a encrypted volume
- `uuid` in `root=UUID=<uuid>` is the UUID of the logical volume of root

## Enable auto update
```bash
systemctl enable systemd-boot-update.service
```

# Finishing the installation
```bash
# Leave chroot
exit

# Unmount partions
unmount -R /mnt
swapoff -a

# Leave archiso
reboot
```

# Post Installation

## User packages

- official repo packages
- `[aur packages]`
- `<source packages>`

```
# Base
zsh bat git ghq vim neovim lf fzf openssh zip unzip stow gnupg tmux wmenu pacman-contrib
eza wget fd ripgrep

# System
iwd systemd-resolvconf sbctl mesa vulkan-radeon ufw ddcutil bluez-utils bluetui <yay>

# Monitor
btop nvtop

# Wayland
foot river-classic <dam> wob wl-clipboard cliphist swaylock swaybg

# Web browser
qutebrowser firefox

# Fonts
noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra
ttf-jetbrains-mono ttf-jetbrains-mono-nerd

# Audio
pipewire pipewire-alsa pipewire-pulse wireplumber

# Password
pass pass-otp

# IME
fcitx5 fcitx5-qt fcitx5-gtk fcitx5-chinese-addons
```


## Setup wireless network

```bash
# Enable the wireless daemon
sudo systemctl enable --now iwd.service

# Enable the DNS resolver daemon
sudo systemctl enable --now systemd-resolved.service
```

Use the `iwctl` to manage/connect the Wi-Fi
```bash
# You will be prompted to enter the passphrase
iwctl station <name> connect <SSID>
```

## `sbctl` Secure Boot

1. Reboot into UEFI setup. Restore the secure boot's factory keys and enter `setup mode`
2. Boot into the system, and check `sbctl status`. You should see:

```

Installed:    ✘ Sbctl is not installed
Setup Mode:   ✘ Enabled
Secure Boot:  ✘ Disabled
```

3. Create your own keys

```shell
sbctl create-keys

```

4. Enroll the keys, with `--microsoft` if need dual boot with Windows

```shell
sbctl encroll-keys [--micronsoft]
```

5. Check the files to sign

```shell
sudo sbctl verify
```

6. Sign the related files

```shell
sudo sbctl sign -s /boot/EFI/BOOT/BOOTX64.EFI
sudo sbctl sign -s /boot/EFI/systemd/systemd-boox64.efi
sudo sbctl sign -s /boot/vmlinuz-linux
```

7. Reboot into UEFI setup and double-check whether the `Secure Boot` is enabled. If not, enable it manually.
8. Boot into the system, and check `sbctl status` again. You should see:

```
Installed:    ✓ sbctl is installed
Setup Mode:   ✓ Disabled
Secure Boot:  ✓ Enabled
```

9. Make sure the `systemd-boot-update.service` is enabled for auto signing the future bootloaders and kernels

## Enable pacman cache cleanup automatically

```bash
# automatically clean pacman cache
# remove unused packages weekly by `paccache` command from `pacman-contrib`
# package. (default keeps the last 3 versions of a package)
systemctl enable --now paccache.timer

```

## `gpg` Import

```bash
gpg --import {{ secret file }}
```

## Updae `mandb`

```bash
sudo mandb
```

## Enable NTP time sync

```bash
systemctl enable --now systemd-timesyncd.service
timedatectl set-ntp true
```

## Enable sshd service

### Force login with key file

edit the `/etc/sshd/sshd_config`

```conf

PasswordAuthentication no
```

```bash
# Enable/Restart
systemctl enable --now sshd.service
```

### Enable sshd-agent

```bash
systemctl enable --now --user ssh-agent.service
```

## Enable `ufw` firewall

```bash
# allow incoming trafic from LAN through ssh port
ufw allow from 192.168.0.0/16 to any app SSH

ufw enable

systemctl enable --now ufw.service

```

## Setup external monitor brightness control

First of all, this step is alternative solution when there's no `backlight` controller found in `/sys/class/backlight`.
Load the `i2c-dev` kernel module by adding new file under `/etc/modules-load.d/i2c-dev.conf`, if the `/dev/i2c-*` devices do not found. `systemd` will handle the modules here during booting.

```conf
# /etc/modules-load/i2c-dev.conf
# Load the `i2c-dev` at boot
i2c-dev

```

And make sure we have the `brightness` VCP feature

```bash
ddcutil capabilities | grep "Feature: 10"

# You should see
# Feature: 10 (Brightness)
```

## Enable Bluetooth

> [!Bug] Since I am using `Mediateck MT7925` chip for both wifi and bluetooth, there's a issue for the bluetooth in the linux kernel.
> [bbs archlinux](https://bbs.archlinux.org/viewtopic.php?id=306366)
> [linux kernel patch](https://lists.openwall.net/linux-kernel/2025/06/06/739)

```bash
systemctl enable --now bluetooth.service
```

## Setup `fcitx5`

install `fcitx5-configtool` for the GUI configure

### Install theme
```bash
git clone https://github.com/catppuccin/fcitx5.git
mkdir -p ~/.local/share/fcitx5/themes/
cp -r ./fcitx5/src/catppuccin-{flavour}-{accent}
```

Update the `theme` variable in fcitx5 config
```conf
# ~/.local/fcitx5/conf/classicui.conf
Theme=catppuccin-{flavour}-{accent}
```

For example if i'm using the `mocha` flavour with `red` accent. Check [palette](https://catppuccin.com/palette) for more options.
```
catppuccin-mocha-red
```
