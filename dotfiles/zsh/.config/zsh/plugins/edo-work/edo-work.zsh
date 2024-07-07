#! /bin/zsh

function __init_work {
  export WORK_DIR="$HOME/Documents/work"

  # Repo dir
  export EDISON_REPO_DIR="$WORK_DIR/agent8"

  alias agent8="cd $EDISON_REPO_DIR"

  # Alias all the sub-folders
  if [[ -d $EDISON_REPO_DIR ]]; then
    eval "$(\ls $EDISON_REPO_DIR | awk -v dir=$EDISON_REPO_DIR '{print "alias " tolower($0)  "=\"cd " dir "/" $0 "\""}')"
  fi
}

__init_work
