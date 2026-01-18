#! /usr/bin/env zsh

export SYSTEM_OS=$(uname | tr '[:upper:]' '[:lower:]')

if [ -f "$HOME/.config/shell/profile.${SYSTEM_OS}" ]; then
  source "$HOME/.config/shell/profile.${SYSTEM_OS}"
else
  source "$HOME/.config/shell/profile.default"
fi

# Create the cache folder for zsh completion and history
if [ ! -d "${XDG_CACHE_HOME}/zsh" ]; then
  mkdir -p "${XDG_CACHE_HOME}/zsh"
fi

if [ -f "$HOME/.zshrc" ]; then
  . "$HOME/.zshrc"
fi
