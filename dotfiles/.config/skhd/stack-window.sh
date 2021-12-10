#!/bin/sh
CUR_WIN=`yabai -m query --windows --window | /usr/local/bin/jq -r ".id"`

case "$1" in
    "west" | "north")
	fallback="last"	
	;;
    "south" | "east")
	fallback="first"
	;;
    *)
	echo "exit due to invalid direction"
	exit 1
esac

yabai -m window $1 --stack $CUR_WIN || yabai -m window $fallback --stack $CUR_WIN

unset CUR_WIN
unset fallback
