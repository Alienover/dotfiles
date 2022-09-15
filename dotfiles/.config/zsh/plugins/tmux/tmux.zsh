#! /bin/zsh
function __get_popup_scale() {
    if [[ $COLUMNS -lt 250 ]]; then
	echo "80%"
    else
	echo "50%"
    fi
}

function __init_env {
	export __TMUX_POPUP_XSCALE="`__get_popup_scale`"
}

__init_env

