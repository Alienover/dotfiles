SELECTED_SESSION=""

pick() {
  if [ -z "$1" ]; then
    exit 0
  elif [ $(echo "$1" | wc -l) == 1 ]; then
    SELECTED_SESSION="$(tmuxifier ls | grep "$1")"
  else
    SELECTED_SESSION="$(echo "$1" | head -n 2 | tail -n 1)"
  fi

}

if [ -n "$1" ]; then
  pick "$1"
else
  C_FG=$GUI_FOREGROUND
  C_BG=$GUI_BACKGROUND
  C_PRIMARY=$GUI_BLUE
  C_YELLOW=$GUI_DARK_YELLOW
  C_BLACK=$GUI_BLACK

  # Refer to https://github.com/junegunn/fzf/wiki/Color-schemes#color-configuration for more detail
  FZF_OPTIONS="
    --no-info
    --margin=1,3
    --height=100%
    --print-query
    --layout=reverse
    --preview-window=down
    --color fg:$C_FG,bg:$C_BG,hl:$C_PRIMARY
    --color fg+:$C_FG,bg+:$C_BLACK,hl+:$C_YELLOW
    --color gutter:$C_BG,info:$C_PRIMARY,prompt:$C_PRIMARY
    --color spinner:$C_PRIMARY,pointer:$C_BLACK,marker:$C_YELLOW,border:$C_BLACK
  "

  MATCHEDS=$(tmux list-sessions -F "#S: #{session_windows} windows #{?session_attached,(attached),}" | \
    grep -v "popup" | fzf $FZF_OPTIONS --prompt "Session: "\
    --preview "echo {} | grep -oE \"^[^:]+\" | xargs -I %% tmux-preview \"%%\"" |\
    sed -E 's/.*[[:space:]]([^:]+):.*/\1/' \
  )

  pick "$MATCHEDS"
fi


if [ -n "$SELECTED_SESSION" ]; then
  tmuxifier load-session $SELECTED_SESSION
else
  echo "No project selected!"
fi

