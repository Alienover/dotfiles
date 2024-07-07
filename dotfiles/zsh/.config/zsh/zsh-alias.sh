#! /usr/bin/env zsh

alias dot="cd $HOME/src/dotfiles"

init_ls_alias() {
  if command -v eza > /dev/null; then
    alias ls="eza"
    alias ll="eza -alh --sort=type"
    alias tree="eza --tree"
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


init_ls_alias
init_cat_alias
