#!/bin/sh

CUR_WIN=`yabai -m query --windows --window | /usr/local/bin/jq -r ".id"`

case "$1" in
    "next")
	fallback="first"
	;;
    "prev")
    fallback="last"
	;;
    *)
    echo "exit due to invalid moving direction"
    exit 1
	;;
esac

yabai -m window --display $1 || yabai -m window --display $fallback
yabai -m window --focus $CUR_WIN

unset CUR_WIN
unset fallback
