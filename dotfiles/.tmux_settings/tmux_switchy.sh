#!/usr/bin/bash

PROJECTS="polaris\nvpn\nterm\nrigel"
WORK_DIR="$HOME/Documents/work/agent8"

PROJECT_NAME=""
PROJECT_ARGS=""

check_is_started() {
    IS_STARTED=$(tmux list-session -F "#S" | fzf -i -1 -0 -q "$1")
}

switch_project() {
    case $1 in
        "polaris")
            PROJECT_NAME="🚀 polaris"
            PROJECT_ARGS="tmux send-keys -t \"$PROJECT_NAME\" \"cd $WORK_DIR/Polaris\" C-m \; \
                send-keys -t \"$PROJECT_NAME\" \"clear\" C-m \; \
                new-window -t \"$PROJECT_NAME\" \; \
                send-keys -t \"$PROJECT_NAME\" \"nvim\" C-m \;
            "
            ;;
        "vpn")
            PROJECT_NAME="🌈 vpn"
            PROJECT_ARGS="tmux send-keys -t \"$PROJECT_NAME\" \"$HOME/v2ray/v2ray\" C-m \; \
                split-window -t \"$PROJECT_NAME\" \; \
                split-window -t \"$PROJECT_NAME\" \; \
                select-layout -t \"$PROJECT_NAME\" tiled \; \
                send-keys -t \"$PROJECT_NAME\" \"clear\" C-m
            "
            ;;
        "term")
            PROJECT_NAME="🦄 term"
            PROJECT_ARGS=""
            ;;
        "rigel")
            PROJECT_NAME="💌 Rigel"
            PROJECT_ARGS="tmux send-keys -t \"$PROJECT_NAME\" \"cd $WORK_DIR/Rigel\" C-m\; \
                new-window -t \"$PROJECT_NAME\" \; \
                send-keys -t \"$PROJECT_NAME\" \"cd $WORK_DIR/Rigel/go/cmd/webmail\" C-m \; \
                send-keys -t \"$PROJECT_NAME\" \"clear\" C-m
            "
            ;;
        *)
            echo "Nothing found!"
            exit
            ;;
    esac
    if [ -n "$PROJECT_NAME" ]; then
        echo "Choose $PROJECT_NAME"
    fi
}

attach() {
    if [ -z "$IS_STARTED" ]; then
        cd "$HOME"
        tmux new-session -d -s "$1"
        if [ $? -ne 1 ] && [ -n "$2" ]; then
            eval "$2"
        fi
    fi
}

switch() {
    tmux switch-client -t "$1"
}

attach_project() {
    attach "$@"
    if [ -n "$TMUX" ]; then
        switch "$1"
    else
        tmux attach-session
    fi
}


SELECTED_PROJECT=$(echo $PROJECTS | fzf --prompt="Project: " -i -1 -0 -q "$1")

if [ -n "$SELECTED_PROJECT" ]; then
    switch_project "$SELECTED_PROJECT"
    check_is_started "$PROJECT_NAME"
    attach_project "$PROJECT_NAME" "$PROJECT_ARGS"
else
    echo "No project selected!"
    exit
fi
