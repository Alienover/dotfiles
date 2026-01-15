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
