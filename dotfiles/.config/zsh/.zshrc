# export ZSH="$HOME/.oh-my-zsh"

# fpath=(/usr/local/share/zsh/site-functions $fpath)

# source "$ZSH/oh-my-zsh.sh"

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

# Load git utils
zsh_add_file "zsh-git.sh"

# Load theme
zsh_add_theme "agnoster"

# Load plugins
# Custom
zsh_add_custom_plugin "fzf"
zsh_add_custom_plugin "perl"
zsh_add_custom_plugin "pyenv"
zsh_add_custom_plugin "cmd-duration"
# From Web
zsh_add_plugin "jeffreytse/zsh-vi-mode"
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"

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
