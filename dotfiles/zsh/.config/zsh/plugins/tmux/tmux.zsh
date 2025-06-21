export TMUXIFIER_LAYOUT_PATH="$HOME/.config/tmuxifier"

# Tmux switchy
alias sw="tmux-switchy"

# Tmuxifier
function __load_tmuxifier {
  export TMUXIFIER_NO_COMPLETE=1

  eval "$(${TMUX_PLUGIN_MANAGER_PATH:-$HOME/.tmux}/tmuxifier/bin/tmuxifier init -)"
}

zsh_lazy_load tmuxifier "__load_tmuxifier"
