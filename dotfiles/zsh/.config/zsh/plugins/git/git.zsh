#! /bin/zsh

function parse_git_dirty() {
  if [[ -n $(git status -z 2> /dev/null) ]]; then
    echo "*"
  else
    echo ""
  fi
}

function __init_alias {
  alias gd="popup-diff"
  alias gl="popup-logs"
  alias gc="git checkout"
  alias gs="git status"
}

__init_alias
