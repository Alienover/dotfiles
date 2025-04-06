#! /usr/bin/env zsh

# Undercurl support
# Refer to: https://github.com/kovidgoyal/kitty/issues/3235#issuecomment-758354252

local has_ghostty=`command -v ghostty`

if [[ -f $has_ghostty ]]; then
  export TERM="xterm-ghostty"
else
  export TERM="xterm-256color"
fi

export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

export LC_ALL=en_US.UTF-8

export DYLD_LIBRARY_PATH=/usr/local/include
export CPPFLAGS="-I/usr/local/include/snappy-c.h"
export CFLAGS="-I/usr/local/include/snappy-c.h"

# ZSH caches and histories
export HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zsh_history"
export ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompdump"

# zsh-vi-mode config
export ZVM_CURSOR_STYLE_ENABLED=false

__init_paths() {
  local ZSH_BIN="$XDG_CONFIG_HOME/zsh/bin"

  local PQ_BIN="/opt/homebrew/opt/libpq/bin"

  export PATH="$ZSH_BIN:$PQ_BIN:$PATH"
}

__init_paths
