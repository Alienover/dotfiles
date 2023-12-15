#! /usr/bin/env zsh

# Undercurl support
# Refer to: https://github.com/kovidgoyal/kitty/issues/3235#issuecomment-758354252

local has_kitty=`command -v kitty`

if [[ -f $has_kitty ]]; then
  export TERM="xterm-kitty"
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

__init_paths() {
  local VS_CODE_BIN="$HOME/Applications/VSCodium.app/Contents/Resources/app/bin"

  local ZSH_BIN="$XDG_CONFIG_HOME/zsh/bin"

  export PATH="$VS_CODE_BIN:$ZSH_BIN:$PATH"
}

__init_paths

# zsh-vi-mode config
export ZVM_CURSOR_STYLE_ENABLED=false

export WORK_DIR="$HOME/Documents/work"

export GO_PROJECTS_PATH=("$WORK_DIR/agent8/Rigel")

export NNN_PLUG="o:fzopen;p:preview-tabbed"

export NNN_FIFO='/tmp/nnn.fifo'
