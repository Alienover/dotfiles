#!/usr/bin/env zsh

export ZDOTDIR=$HOME/.config/zsh

export SYSTEM_OS=$(uname | tr '[:upper:]' '[:lower:]')

if [ -f "$HOME/.config/shell/env.${SYSTEM_OS}" ]; then
  source "$HOME/.config/shell/env.${SYSTEM_OS}"
else
  source "$HOME/.config/shell/env.default"
fi
