#! /bin/zsh

if [ "$(tmux display-message -p -F "#{session_name}")" = "popup" ];then
    tmux detach-client -s 'popup'
else
    tmux attach -t popup || tmux new -s popup
fi
