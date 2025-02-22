#! /bin/zsh
function __init_env {
  local TMUX_BIN="$XDG_CONFIG_HOME/tmux/bin"
  local TMUXIFIER_BIN="$XDG_CONFIG_HOME/tmux/plugins/tmuxifier/bin"

  export PATH="$PATH:$TMUX_BIN:$TMUXIFIER_BIN"

  export TMUXIFIER_LAYOUT_PATH="$HOME/.config/tmuxifier"

  # Tmux switchy
  alias sw="sh $XDG_CONFIG_HOME/tmux/switchy.sh"
}

# Tmuxifier
function __load_tmuxifier {
  export TMUXIFIER_NO_COMPLETE=1
  eval "$(tmuxifier init -)"
}

__init_env

zsh_lazy_load tmuxifier "__load_tmuxifier"
