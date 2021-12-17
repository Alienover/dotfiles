#!/bin/bash
SPAC_LEN=`yabai -m query --spaces | /usr/local/bin/jq 'map(select(.windows|length > 0)) | length'`
__HYPER="cmd + alt + ctrl"
if [[ "$1" > "$SPAC_LEN" ]]; then
    skhd -k "$__HYPER - $SPAC_LEN"
    skhd -k "$__HYPER - 0x1E"
else
    skhd -k "$__HYPER - $1"
fi

unset SPAC_LEN
unset __HYPER
