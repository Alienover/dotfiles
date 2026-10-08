# Setup `pinentry-mac`

1. Install it by `homebrew`
```sh
brew install pinentry-mac
```

2. Set the `pinentry-program` to it in the config for `gpg-agent` and restart the `gpg-agent`
```sh
echo "pinentry-program /opt/homebrew/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf

killall gpg-agent
```

3. Enable the terminal (Alacritty/Ghostty/Kitty) in `Settings -> Privacy & Security -> Accessibility`, add it to the list if it's not on the list

# Setup DevPod

1. Install the `devpod` CLI (or install it from DevPod Desktop -> Settings)
```sh
brew install devpod
```

2. Configure the DevPod context, provider and default IDE. Safe to run repeatedly
```sh
./install/darwin/install-devpod-config
```

It enables SSH agent forwarding and sets `DOTFILES_URL` (defaults to this repo's `origin`) and `DOTFILES_SCRIPT` (defaults to `devpod-bootstrap`), so workspaces get bootstrapped with these dotfiles. Override the defaults via environment variables:

| Variable          | Default            |
| ----------------- | ------------------ |
| `DEVPOD_CONTEXT`  | `default`          |
| `DEVPOD_PROVIDER` | `docker`           |
| `DEVPOD_IDE`      | `none`             |
| `DOTFILES_URL`    | git `origin` URL   |
| `DOTFILES_SCRIPT` | `devpod-bootstrap` |
