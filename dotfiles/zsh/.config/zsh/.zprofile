#! /usr/bin/env zsh

export SYSTEM_OS=$(uname | tr '[:upper:]' '[:lower:]')

if [ -f "$HOME/.config/shell/profile.${SYSTEM_OS}" ]; then
  source "$HOME/.config/shell/profile.${SYSTEM_OS}"
else
  source "$HOME/.config/shell/profile.default"
fi
