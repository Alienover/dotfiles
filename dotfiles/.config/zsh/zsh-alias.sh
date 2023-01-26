#! /bin/zsh

# Proxychains
alias proxychains="`which proxychains4`"

# Directories
alias ls="ls --color=always"
alias ll="ls -lh"

alias goproxy="GOPROXY=https://goproxy.cn,direct go"

init_config_alias() {
  local MY_CONFIG_DIR="$HOME/.config"

  # Tmux switchy
  alias sw="sh $MY_CONFIG_DIR/tmux/tmux_switchy.sh"
}

init_config_alias
