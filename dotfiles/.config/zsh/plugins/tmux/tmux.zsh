#! /bin/zsh

function __init_env {
    if [[ $COLUMNS -lt 250 ]]; then
	export __TMUX_POPUP_SCALE="80%"
    else
	export __TMUX_POPUP_SCALE="50%"
    fi
}

__init_env

function __get_popup_scale() {
    if [[ $COLUMNS -lt 250 ]]; then
	echo "80%"
    else
	echo "50%"
    fi
}
