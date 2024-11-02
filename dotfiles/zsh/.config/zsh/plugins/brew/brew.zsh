#! /bin/zsh
# Place your plugin content here
source "$ZDOTDIR/zsh-functions.zsh"

function __init_env {
  local BREW_PREFIX="/opt/homebrew"

  local BREW_BIN="$BREW_PREFIX/bin"
  local BREW_SBIN="$BREW_PREFIX/sbin"

  export PATH="$BREW_BIN:$BREW_SBIN:$PATH"

  export HOMEBREW_NO_INSTALL_FROM_API=1

  # Specify your defaults in this environment variable
  export HOMEBREW_CASK_OPTS="--appdir=$HOME/Applications --fontdir=/Library/Fonts"
}

# Brew
function __load_brew {
  eval "$(/opt/homebrew/bin/brew shellenv)"
}

__init_env

zsh_lazy_load brew "__load_brew"
