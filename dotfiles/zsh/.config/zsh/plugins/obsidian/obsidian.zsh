#! /usr/bin/env zsh

CURRENT_PATH="${0:A:h}"

__init_env() {
  case "$(uname)" in
    "Darwin")
      export OBSIDIAN_VAULT="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/Obsidian"
      ;;;
    *)
      # Fallback
      export OBSIDIAN_VAULT="$HOME/Documents/Obsidian"
  esac

  local OBSIDIAN_BIN="${CURRENT_PATH}/scripts"

  export PATH="${OBSIDIAN_BIN}:${PATH}"
}

__init_env

alias obsidian="cd '$OBSIDIAN_VAULT'"
