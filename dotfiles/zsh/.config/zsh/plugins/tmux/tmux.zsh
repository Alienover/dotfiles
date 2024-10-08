#! /bin/zsh
function __init_env {
  local TMUX_BIN="$XDG_CONFIG_HOME/tmux/bin"

  export PATH="$PATH:$TMUX_BIN"

  # Tmux switchy
  alias sw="sh $XDG_CONFIG_HOME/tmux/switchy.sh"
}

__init_env
