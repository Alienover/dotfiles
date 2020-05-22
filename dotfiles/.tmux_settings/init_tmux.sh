#!/usr/bin/bash

cd $HOME/Documents/work/agent8/Polaris
tmux new-session -s "🚀 polaris" \; \
    send-keys "tmux detach" C-m \;

cd $HOME
tmux new-session -s "🌈 vpn" \; \
    send-keys "$HOME/v2ray/v2ray" C-m \; \
    split-window -v \; \
    send-keys "tmux detach" C-m \;

tmux new-session -s "🦄 term"
