# Install packages

- official repo packages
- \[aur packages\]
- <source packages>

```
# Base
zsh bat git ghq vim neovim lf fzf openssh zip unzip stow gnupg tmux wmenu pacman-contrib
eza wget lf fd 

# System
networkmanager sbctl mesa vulkan-radeon ufw ddcutil bluez-utils bluetui <yay>

# Monitor
btop nvtop

# Wayland
foot river <dam> wob wl-clipboard cliphist swaylock swaybg

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

# `sbctl` Secure Boot

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
sudo sbctl sign-all
sudo sbctl sign -s /boot/EFI/BOOT/BOOTX64.EFI
sudo sbctl sign -s /boot/EFI/systemd/systemd-boox64.efi
sudo sbctl sign -s /boot/vmlinuz-linux
sudo sbctl sign -s -o /usr/lib/systemd/boot/efi/systemd-bootx64.efi.signed /usr/lib/systemd/boot/efi/systemd-bootx64.efi
```

7. Reboot into UEFI setup and double-check whether the `Secure Boot` is enabled. If not, enable it manually.
8. Boot into the system, and check `sbctl status` again. You should see:

```
Installed:    ✓ sbctl is installed
Setup Mode:   ✓ Disabled
Secure Boot:  ✓ Enabled
```

9. Make sure the `systemd-boot-update.service` is enabled for auto signing the future bootloaders and kernels

# Enable pacman cache cleanup automatically

```bash
# automatically clean pacman cache
# remove unused packages weekly by `paccache` command from `pacman-contrib`
# package. (default keeps the last 3 versions of a package)
systemctl enable --now paccache.timer

```

# `gpg` Import

```bash
gpg --import {{ secret file }}
```

# Updae `mandb`

```bash
sudo mandb
```

# Enable NTP time sync

```bash
systemctl enable --now systemd-timesyncd.service
timedatectl set-ntp true
```

# Enable sshd service

## Force login with key file

edit the `/etc/sshd/sshd_config`

```conf

PasswordAuthentication no
```

```bash
# Enable/Restart
systemctl enable --now sshd.service
```

## Enable sshd-agent

```bash
systemctl enable --now --user ssh-agent.service
```

# Enable `ufw` firewall

```bash
# allow incoming trafic from LAN through ssh port
ufw allow from 192.168.0.0/16 to any app SSH

ufw enable

systemctl enable --now ufw.service

```

# Setup external monitor brightness control

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

# Enable Bluetooth

> [!Bug] Since I am using `Mediateck MT7925` chip for both wifi and bluetooth, there's a issue for the bluetooth in the linux kernel.
> [bbs archlinux](https://bbs.archlinux.org/viewtopic.php?id=306366)
> [linux kernel patch](https://lists.openwall.net/linux-kernel/2025/06/06/739)

```bash
systemctl enable --now bluetooth.service
```

# Setup `sshd` to force login with keys
edit `/etc/ssh/sshd_config`
```conf
# uncomment this line
PasswordAuthentication no
```

## Enable `sshd` and `ssh-agent`
```bash
systemctl enable --now sshd.service

systemctl enable --user --now ssh-agent.service
```

# Setup `fcitx5`

install `fcitx5-configtool` for the GUI configure

## Install theme
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
