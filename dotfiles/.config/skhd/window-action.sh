#!/bin/bash
CUR_WIN=`yabai -m query --windows --window | jq -r ".id"`

CMD="$1"

case "$2" in
  "west" | "north")
    fallback="last"
    ;;
  "south" | "east")
    fallback="first"
    ;;
  *)
    echo "exit due to invald direction"
    exit 1
esac

echo "yabai -m window $2 --$CMD $CUR_WIN || yabai -m window $fallback --$CMD $CUR_WIN"
eval "yabai -m window $2 --$CMD $CUR_WIN || yabai -m window $fallback --$CMD $CUR_WIN"

unset CUR_WIN
unset CMD
unset fallback
