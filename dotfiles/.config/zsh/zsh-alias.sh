#! /bin/zsh

# Directories
alias ls="ls --color=always"
alias ll="ls -lh"

init_proxy_alias() {
  # Proxychains
  alias proxychains="`which proxychains4`"


  alias goproxy="GOPROXY=https://goproxy.cn,direct go"
}

init_config_alias() {
  local MY_CONFIG_DIR="$HOME/.config"

  # Tmux switchy
  alias sw="sh $MY_CONFIG_DIR/tmux/switchy.sh"
}

init_config_alias
