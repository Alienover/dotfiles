#! /bin/zsh

if [ "$(tmux display-message -p "#{session_name}")" = "popup" ]; then
  tmux detach-client
fi

tmux popup -w70 -h15 -y0 -E "sh $XDG_CONFIG_HOME/tmux/tmux_switchy.sh"
