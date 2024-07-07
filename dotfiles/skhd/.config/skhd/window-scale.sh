#!/bin/bash

case "$1" in
  "down")
    yabai -m window --resize left:50:0
    yabai -m window --resize right:-50:0
    yabai -m window --resize top:0:25
    yabai -m window --resize bottom:0:-25
    ;;
  "up")
    WINDOW_FLOATING=`yabai -m query --windows --window | jq -r '.["is-floating"]'`
    SPACE_TYPE=`yabai -m query --spaces --space | jq -r ".type"`

    if [[ "$WINDOW_FLOATING" == "true" || "$SPACE_TYPE" == "float" ]]; then
      yabai -m window --resize left:-50:0
      yabai -m window --resize right:50:0
      yabai -m window --resize top:0:-25
      yabai -m window --resize bottom:0:25
    else
      yabai -m space --balance
    fi
    ;;
esac
