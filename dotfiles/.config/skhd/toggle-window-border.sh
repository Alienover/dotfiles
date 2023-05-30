#1 /bin/sh

if [[ "$(yabai -m query --windows | jq '.[]."has-border"' | uniq | sort | tail -n 1)" == "true" ]]; then
  yabai -m config window_border off
else
  yabai -m config window_border on
fi
