#! /usr/bin/env zsh

export ZDOTDIR="$HOME/.config/zsh"

source "$ZDOTDIR/zsh-functions.sh"

# Paths
zsh_add_file "zsh-exports.sh"

# User configuration

# !! Attention
# Place under omz initialization to overwrite the color definination
# Load Customized color scheme
zsh_add_file "zsh-colors.sh"

# Load alias
zsh_add_file "zsh-alias.sh"

# Load theme
zsh_add_theme "agnoster"

# From Web
zsh_add_plugin "jeffreytse/zsh-vi-mode"
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zdharma-continuum/fast-syntax-highlighting"

# Completions
autoload -Uz compinit

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' list-colors ''
# suggest case insensitive e.g.: cd docu -> cd Documents
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompcache"

zmodload zsh/complist

# Include hidden files
_comp_options+=(globdots)

compinit -d $ZSH_COMPDUMP

# Load plugins
# -- Work
zsh_add_custom_plugin "edo-work"
# -- Custom
zsh_add_custom_plugin "brew"
zsh_add_custom_plugin "cmd-duration"
zsh_add_custom_plugin "fnm"
zsh_add_custom_plugin "fzf"
zsh_add_custom_plugin "git"
zsh_add_custom_plugin "go"
zsh_add_custom_plugin "pyenv"
zsh_add_custom_plugin "tmux"
zsh_add_custom_plugin "nvim"
# TODO: support transient-prompt
zsh_add_custom_plugin "transient-prompt"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
