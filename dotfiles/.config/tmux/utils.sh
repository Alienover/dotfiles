#! /bin/zsh

local arg="$1"

get_window_sizing() {
  local scale="50%"
  local window_width=$(tmux display-message -p "#{window_width}")

  if [[ $window_width -lt 250 ]]; then
    scale="80%"
  fi

  echo $scale
  exit 0
}

if [[ $arg == "scale" ]]; then
  get_window_sizing
fi
