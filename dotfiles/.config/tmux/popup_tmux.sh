__SCALE="50%"


if [ "$(tmux display-message -p -F "#{session_name}")" = "popup" ];then
    tmux detach-client
else
    tmux popup -xC -yC -w $__SCALE -h $__SCALE -E "tmux attach -t popup || tmux new -s popup"
fi
