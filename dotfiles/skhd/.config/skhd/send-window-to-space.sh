#!/bin/sh
CUR_SPAC=`yabai -m query --spaces --space | jq -r ".index"`
if [[ "$CUR_SPAC" != "$1" ]]; then
    CUR_WIN=`yabai -m query --windows --window | jq -r ".id"`
    yabai -m window --space $1
    yabai -m window --focus $CUR_WIN

    unset CUR_WIN
fi

unset CUR_SPAC
