#! /bin/zsh

function __init_alias {
  alias agent8="cd $EDISON_REPO_DIR"

  # Alias all the sub-folders
  if [[ -d $EDISON_REPO_DIR ]]; then
    eval "$(\ls $EDISON_REPO_DIR | awk -v dir=$EDISON_REPO_DIR '{print "alias " tolower($0)  "=\"cd " dir "/" $0 "\""}')"
  fi
}

function __init_env {
  # Repo dir
  export EDISON_REPO_DIR="$WORK_DIR/agent8"

}

__init_env
__init_alias
