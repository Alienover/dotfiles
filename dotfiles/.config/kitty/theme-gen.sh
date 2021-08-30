#!/bin/bash

function parse_theme() {
    local TARGET="$HOME/.config/kitty/theme.sh"

    if [[ ! -f "$TARGET" ]] then
	touch "$TARGET"
    else
	echo "" > "$TARGET"
    fi

    set_env() {
	local NAME="GUI_$(echo $1 | tr a-z A-Z)"

	export "$NAME"="$2"
    }

    while IFS= read -r line; do
	local LINE="`echo $line | xargs`"
	if [[ -n "`echo $LINE | grep -v "^#"`" ]]
	then
	    local NAME="GUI_$(echo $LINE | cut -d\  -f1 | tr a-z A-Z)"
	    local VALUE=$(echo $LINE | cut -d\  -f2)

	    echo "export $NAME=\"$VALUE\"" >> "$TARGET"
	fi
    done < "$1"

    unset -f set_env
}

parse_theme "$1"
