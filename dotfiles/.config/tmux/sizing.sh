#! /bin/zsh

get_window_width() {
  local scale="50%"
  local window_width=$(tmux display-message -p "#{window_width}")

  if [[ $window_width -lt 250 ]]; then
    scale="80%"
  fi

  echo $scale
  exit 0
}

get_window_height() {
  local scale="50%"
  local window_height=$(tmux display-message -p "#{window_height}")

  if [[ $window_height -lt 70 ]]; then
    scale="80%"
  fi

  echo $scale
  exit 0
}
