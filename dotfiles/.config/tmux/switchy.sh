#!/usr/bin/zsh

# Inspired by https://github.com/camspiers/tmuxinator-fzf-start/blob/master/tmuxinator-fzf-start.sh
#
# Usage:
#
# tmux_switchy.sh
# tmux_switchy.sh "Query"
#
# Expectations:
#
# - fzf is on $PATH
# - tmux is on $PATH

PROJECT_POLARIS="🚀 Polaris"
PROJECT_RIGEL="💌 Rigel"
PROJECT_VPN="🌈 vpn"
PROJECT_TERM="🦄 term"
PROJECT_LEETCODE="📚 Leetcode"
PROJECT_POPUP="popup"
PROJECTS="$PROJECT_POLARIS\n$PROJECT_RIGEL\n$PROJECT_VPN\n$PROJECT_TERM\n$PROJECT_LEETCODE"

# Custom variables
WORK_DIR="$HOME/Documents/work/agent8"

# Tmux session name for the target project
PROJECT_NAME=""
# Working root for the target project
PROJECT_ROOT=""
# Commands while initializing project
PROJECT_ARGS=""

check_is_started() {
  IS_STARTED=$(tmux list-session -F "#S" | fzf -i -1 -0 -q "$1")
}

search_project() {
  case $1 in
    "$PROJECT_POLARIS")
      PROJECT_NAME="$PROJECT_POLARIS"
      PROJECT_ROOT="$WORK_DIR/Polaris"
      PROJECT_ARGS="tmux split-window -t \"$PROJECT_NAME\" \; \
        new-window -t \"$PROJECT_NAME\" \;
      "
      ;;
      "$PROJECT_VPN")
          PROJECT_NAME="$PROJECT_VPN"
          PROJECT_ROOT="$HOME"
          # tmux send-keys -t \"$PROJECT_NAME\" \"make proxy\" C-m \;
          PROJECT_ARGS="tmux split-window -t \"$PROJECT_NAME\" \; \
              split-window -t \"$PROJECT_NAME\" \; \
              select-layout -t \"$PROJECT_NAME\" tiled \; \
              resize-pane -t \"$PROJECT_NAME\" -U 20\;
      "
      ;;
    "$PROJECT_TERM")
      PROJECT_NAME="$PROJECT_TERM"
      PROJECT_ROOT="$HOME"
      PROJECT_ARGS=""
      ;;
    "$PROJECT_RIGEL")
      PROJECT_NAME="$PROJECT_RIGEL"
      PROJECT_ROOT="$WORK_DIR/Rigel"
      PROJECT_ARGS=""
      ;;
    "$PROJECT_LEETCODE")
      PROJECT_NAME="$PROJECT_LEETCODE"
      PROJECT_ARGS=""
      ;;
    *)
      echo "Nothing found!"
      exit 0
      ;;
  esac

  if [ -n "$PROJECT_NAME" ]; then
    echo "Choose $PROJECT_NAME"
  fi
}

attach() {
  if [ -z "$IS_STARTED" ]; then
    # Jump to project root
    if [ -n "$PROJECT_ROOT" ]; then
      cd "$PROJECT_ROOT"
    else
      cd "$HOME"
    fi

    # Start the tmux session
    tmux new-session -d -s "$1"
    if [ $? -ne 1 ] && [ -n "$2" ]; then
      eval "$2"
    fi

    # Go back
    cd -
  fi
}

switch() {
  tmux switch-client -t "$1"
}

attach_project() {
  # Start the tmux session
  attach "$@"

  if [ -n "$TMUX" ]; then
    # switch to target session
    switch "$1"
  else
    # Attach to tmux server
    tmux attach-session -t "$1"
  fi

  exit 0
}

pick() {
  SELECTED_PROJECT=$(printf "$PROJECTS" | fzf -f "$1")
}

C_FG=$GUI_FOREGROUND
C_BG=$GUI_BACKGROUND
C_PRIMARY=$GUI_BLUE
C_YELLOW=$GUI_DARK_YELLOW
C_BLACK=$GUI_BLACK

# Refer to https://github.com/junegunn/fzf/wiki/Color-schemes#color-configuration for more detail
FZF_OPTIONS="
--no-info
--layout=reverse
--margin=1,3
--height=100%
--color fg:$C_FG,bg:$C_BG,hl:$C_PRIMARY
--color fg+:$C_PRIMARY,bg+:$C_BLACK,hl+:$C_YELLOW
--color gutter:$C_BG,info:$C_PRIMARY,prompt:$C_PRIMARY
--color spinner:$C_PRIMARY,pointer:$C_BLACK,marker:$C_YELLOW,border:$C_BLACK
"

if [ -n "$1" ]; then
  MATCHEDS=$(echo "$1" | grep -oE "^[^:]+")
else
  MATCHEDS=$(tmux list-sessions -F "#S: #{session_windows} windows #{?session_attached,(attached),}" | grep -v "$PROJECT_POPUP" | fzf $FZF_OPTIONS --preview "echo {} | grep -oE \"^[^:]+\" | xargs -I %% tmux-preview \"%%\"" --preview-window down --prompt "Project: " --print-query | grep -oE "^[^:]+")
fi

for EACH in $MATCHEDS; do
  pick "$EACH"
  if [ -n "$SELECTED_PROJECT" ]; then
    break
  fi
done

if [ -n "$SELECTED_PROJECT" ]; then
  # Search the project by fzf search
  search_project "$SELECTED_PROJECT"
else
  echo "No project selected!"
  exit 0
fi

# Check if the project is started
check_is_started "$PROJECT_NAME"

# Attach or switch to the target project
attach_project "$PROJECT_NAME" "$PROJECT_ARGS"
