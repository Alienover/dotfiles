#! /bin/zsh

function __init_env {
    # Go Path
    export GOBIN="$HOME/go/bin"

    local GO_EXE_BIN="/usr/local/go/bin"
    export PATH="$GO_EXE_BIN:$GOBIN:$PATH"
}

__init_env
