width=${2:-50%}
height=${2:-50%}

if [ "$(tmux display-message -p -F "#{session_name}")" = "popup" ];then
    tmux detach-client
else
    tmux popup -xC -yC -w$width -h$height -E "tmux attach -t popup || tmux new -s popup"
fi
