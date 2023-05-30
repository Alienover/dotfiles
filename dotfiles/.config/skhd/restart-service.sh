#! /bin/sh

SERVICE="$1"

/usr/bin/osascript <<< "display notification \"Restarting $1\" with title \"Restart Service\""

kill -HUP $(pgrep -f $1)
