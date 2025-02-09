#! /usr/bin/env zsh

function __init_env() {
  export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
}

__init_env
