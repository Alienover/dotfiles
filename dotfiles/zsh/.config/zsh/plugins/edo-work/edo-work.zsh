#!/usr/bin/env bash

function __init_work {
  local repos_root="$HOME/Documents/dev"

  # Alias all the sub-folders
  if [ -d $repos_root ]; then
    eval "$(ls $repos_root | grep -v share | awk -v dir=$repos_root '{print "alias " tolower($0)  "=\"cd " dir "/" $0 "\""}')"
  fi
}

__init_work
