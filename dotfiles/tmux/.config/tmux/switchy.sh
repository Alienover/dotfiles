#!/usr/bin/env zsh

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

local -A term=(
  [name]="term"
  [icon]="🦄"
)

local -A polaris=(
  [name]="Polaris"
  [icon]="🚀"
  [root]="!ghq list -p polaris"
  [cmd]=(
    "split-window"
    "new-window"
  )
)

local -A vpn=(
  [name]="vpn"
  [icon]='🌈'
  [cmd]=(
    "split-window"
    "split-window"
    "select-layout tiled"
    "resize-pane -U 20"
  )
)

local -A popup=(
  [name]='popup'
  [hidden]=1
)

local -A spendhound=(
  [name]="SpendHound"
  [icon]="🔖"
  [root]="!ghq list -p spendhound"
)

local sessions=(
  term
  polaris
  vpn
  popup
  spendhound
)

local SELECTED_SESSION=""

# Tmux session name for the target session
local SESSION_NAME=""
# Working root for the target session
local SESSION_ROOT=""
# Commands while initializing session
local SESSION_CMD=""

format_session_name() {
  echo "$1 $2" | xargs
}

parse_cmd() {
  local target="$1"
  local cmds=(${(f)2//[()]/})

  local output=""

  for cmd in $cmds; do
    local cmd=`echo $cmd | xargs`

    if [[ "${#cmd[@]}" > 0 ]]; then
      cmd=(${(s: :)cmd})

      output+="tmux ${cmd[1]} -t \"$target\" ${cmd[@]:1}; "
    fi
  done

  echo "$output"
}

parse_root() {
  local root="${1}"

  if [ -n "$root" ] && [[  "${root:0:1}" == "!" ]]; then
    root=`eval "${root:1}"`
  fi

  echo "$root"
}

search_session() {
  local -A session=("${(Pkv@)1}")

  SESSION_NAME=`format_session_name $session[icon] $session[name]`
  SESSION_ROOT=`parse_root $session[root]`
  SESSION_CMD=`parse_cmd $SESSION_NAME ${session[cmd]}`

  if [ -n "$SESSION_NAME" ]; then
    echo "Choose $SESSION_NAME"
  fi
}

setup_session() {
  # Check if the session is created
  local is_created="$(tmux list-session -F "#S" | grep "$SESSION_NAME")"

  if [ -z "$is_created" ]; then

    # Jump to session root
    if [ -n "$SESSION_ROOT" ]; then
      cd "$SESSION_ROOT"
    else
      cd "$HOME"
    fi

    # Start the tmux session
    tmux new-session -d -s "$SESSION_NAME"
    if [ $? -ne 1 ] && [ -n "$SESSION_CMD" ]; then
      eval "$SESSION_CMD"
    fi

    # Go back
    cd -
  fi
}

attach_session() {
  # Start the tmux session
  setup_session

  if [ -n "$TMUX" ]; then
    # switch to target session
    tmux switch-client -t "$SESSION_NAME"
  else
    # Attach to tmux server
    tmux attach-session -t "$SESSION_NAME"
  fi

  exit 0
}

pick() {
  local -A options=()
  for each in $sessions; do
    local -A session=("${(Pkv@)each}")

    if [[ ${session[hidden]} != 1 ]]; then
      local title=`format_session_name $session[icon] $session[name]`

      options[$title]=$each
    fi

  done

  local selected=`for name in ${(k)options}; do echo $name; done | fzf -1 -f "$1"`

  SELECTED_SESSION="${options[$selected]}"
}


if [ -n "$1" ]; then
  MATCHEDS=$(echo "$1" | grep -oE "^[^:]+")
else
  C_FG=$GUI_FOREGROUND
  C_BG=$GUI_BACKGROUND
  C_PRIMARY=$GUI_BLUE
  C_YELLOW=$GUI_DARK_YELLOW
  C_BLACK=$GUI_BLACK

  # Refer to https://github.com/junegunn/fzf/wiki/Color-schemes#color-configuration for more detail
  FZF_OPTIONS=(
    --no-info
    --layout=reverse
    --margin=1,3
    --height=100%
    --color fg:$C_FG,bg:$C_BG,hl:$C_PRIMARY
    --color fg+:$C_FG,bg+:$C_BLACK,hl+:$C_YELLOW
    --color gutter:$C_BG,info:$C_PRIMARY,prompt:$C_PRIMARY
    --color spinner:$C_PRIMARY,pointer:$C_BLACK,marker:$C_YELLOW,border:$C_BLACK
  )


  MATCHEDS=$(tmux list-sessions -F "#S: #{session_windows} windows #{?session_attached,(attached),}" | grep -v $popup[name] | fzf $FZF_OPTIONS --preview "echo {} | grep -oE \"^[^:]+\" | xargs -I %% tmux-preview \"%%\"" --preview-window down --prompt "Session: " --print-query | grep -oE "^[^:]+")
fi

while read -r line; do
  pick "$line"

  if [ -n "$SELECTED_SESSION" ]; then
    search_session "$SELECTED_SESSION"
    break
  fi
done <<< "$MATCHEDS"

if [ -z "$SELECTED_SESSION" ]; then
  echo "No project selected!"
  exit 0
fi

# Attach or switch to the target project
attach_session
