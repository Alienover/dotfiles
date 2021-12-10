#!/bin/sh
yabai -m display --focus $1
CUR_SPAC=`yabai -m query --spaces | /usr/local/bin/jq -r ".[] | select(.display == $1 and .\"has-focus\").index" | head -n 1`
FIRST_WIN=`yabai -m query --windows | /usr/local/bin/jq -r ".[] | select(.display == $1 and .app != \"Hammerspoon\" and .space == $CUR_SPAC).id" | head -n 1`
yabai -m window --focus $FIRST_WIN

unset CUR_SPAC
unset FIRST_WIN
