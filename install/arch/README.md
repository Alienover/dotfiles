# Install packages

- official repo packages
- \[aur packages\]
- <source packages>

```
# Base
zsh bat git ghq vim neovim lf fzf openssh zip unzip stow gnupg tmux wmenu pacman-contrib
eza wget lf

# System
networkmanager sbctl mesa vulkan-radeon ufw ddcutil

# Monitor
btop nvtop

# Wayland
foot river <dam> wob wl-clipboard cliphist

# Web browser
qutebrowser firefox

# Fonts
noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra
ttf-jetbrains-mono ttf-jetbrains-mono-nerd

# Audio
pipewire pipewire-alsa pipewire-pulse wireplumber
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

4. Encroll the keys, with `--microsoft` if need dual boot with Windows

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
