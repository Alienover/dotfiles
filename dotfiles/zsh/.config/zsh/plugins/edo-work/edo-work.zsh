#! /bin/zsh

function __init_work {
  local repos_root="$(ghq root)"
  export WORK_DIR="$HOME/Documents/work"

  # Repo dir
  export EDISON_REPO_DIR="$repos_root/github.com/agent8"
  export YIPIT_REPO_DIR="$repos_root/github.com/Yipit"

  export WORK_REPO_DIRS=(
    "$repos_root/github.com/agent8"
    "$repos_root/github.com/Yipit"
  )

  # Alias all the sub-folders
  for root in $WORK_REPO_DIRS; do
    eval "$(\ls $root | awk -v dir=$root '{print "alias " tolower($0)  "=\"cd " dir "/" $0 "\""}')"
  done

  export WORK_CONFIG_DIR="$HOME/Documents/work/others"
}

__init_work
