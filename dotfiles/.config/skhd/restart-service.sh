#! /bin/sh

SERVICE="$1"

/usr/bin/osascript <<< "display notification \"Restarting $1\" with title \"Restart Service\""

eval "$1 --restart-service"
