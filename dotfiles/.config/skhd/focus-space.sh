#!/bin/sh

TARGET_SPACE="$1"

CURR_DISPLAY=`yabai -m query --displays --display | jq '.id'`
TARGET_DISPLAY=`yabai -m query --spaces | jq ".[] | select(.index == $TARGET_SPACE).display"`

if [ "$CURR_DISPLAY" != "$TARGET_DISPLAY" ]; then
  sh ~/.config/skhd/focus-display.sh "$TARGET_DISPLAY"
fi

osascript -l JavaScript -e "$(cat << "EOF"
  function switchDesktop(desktopNumber) {
    var systemEvents = Application("System Events");

    try {
      var pressedKey = `${parseInt(desktopNumber) + 17}`;
      systemEvents.keyCode(pressedKey, {
        using: ["option down", "control down", "command down"],
      });
    } catch (e) {
      console.log("Invalid desktop number");
    }
  }

  function run(argv) {
    if (argv.length > 0) {
      switchDesktop(argv[0]);
    } else {
      console.log("Usage: switch-desktop.js <desktopNumber>");
    }
  }
EOF)" "$TARGET_SPACE"
