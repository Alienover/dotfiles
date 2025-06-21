#! /usr/bin/env zsh

if [ -f "$HOME/.config/shell/profile.${SYSTEM_OS}" ]; then
  source "$HOME/.config/shell/profile.${SYSTEM_OS}"
else
  source "$HOME/.config/shell/profile.default"
fi
