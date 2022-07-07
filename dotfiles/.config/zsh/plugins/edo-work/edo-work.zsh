#! /bin/zsh

function __init_alias {
    alias agent8="cd $EDISON_REPO_DIR"

    # Alias all the sub-folders
    eval "$(ls $EDISON_REPO_DIR | awk -v dir=$EDISON_REPO_DIR '{print "alias " tolower($0)  "=\"cd " dir "/" $0 "\""}')"
    # alias ops="cd $EDISON_REPO_DIR/Ops"
    # alias titan="cd $EDISON_REPO_DIR/Titan"
    # alias rigel="cd $EDISON_REPO_DIR/Rigel"
    # alias utils="cd $EDISON_REPO_DIR/Utils"
    # alias saturn="cd $EDISON_REPO_DIR/Saturn"
    # alias polaris="cd $EDISON_REPO_DIR/Polaris"
}

function __init_env {
    local MY_WORK_DIR="$HOME/Documents/work"

    # Repo dir
    export EDISON_REPO_DIR="$MY_WORK_DIR/agent8"

}

__init_env
__init_alias
