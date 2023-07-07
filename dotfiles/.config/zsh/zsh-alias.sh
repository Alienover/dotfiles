#! /usr/bin/env zsh

init_ls_alias() {
  if command -v exa > /dev/null; then
    alias ls="exa"
    alias ll="exa -alh --sort=newest"
    alias tree="exa --tree"
  else
    alias ls="ls --color=always"
    alias ll="ls -lh"
  fi
}

init_cat_alias() {
  if command -v bat > /dev/null; then
    alias cat="bat"
  fi
}

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

init_ls_alias
init_cat_alias
init_config_alias
