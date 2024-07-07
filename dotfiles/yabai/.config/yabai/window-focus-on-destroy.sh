#!/bin/bash

isFocused=$(yabai -m query --windows --window | jq -re ".id")
currSpace=$(yabai -m query --spaces --space | jq -re ".index")
echo $isFocused
if [[ -z "$isFocused" ]]; then # -z >> true if it's null
    # $(yabai -m window --focus $(yabai -m query --windows | jq -re ".[] | select((.visible == 1) and .focused != 1).id" | head -n 1))
    yabai -m window --focus `yabai -m query --windows | jq -re ".[] | select(.\"is-visible\" and .\"has-focus\" == false and .space == ${currSpace}).id" | head -n 1`
fi
