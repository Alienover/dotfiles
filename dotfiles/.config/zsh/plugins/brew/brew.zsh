#! /bin/zsh
# Place your plugin content here
source "$ZDOTDIR/zsh-functions.sh"

function __init_env {
    local BREW_PREFIX="/opt/homebrew"

    local BREW_BIN="$BREW_PREFIX/bin"
    local BREW_SBIN="$BREW_PREFIX/sbin"

    export PATH="$BREW_BIN:$BREW_SBIN:$PATH"
}

# Brew
function __load_brew {
    eval "$(/opt/homebrew/bin/brew shellenv)"
}

__init_env

zsh_lazy_load brew "__load_brew"
