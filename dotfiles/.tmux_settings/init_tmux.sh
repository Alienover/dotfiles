#!/usr/bin/bash

tmux new-session -s "🚀 polaris" \; \
    send-keys "cd $HOME/Documents/work/agent8/Polaris" C-m \; \
    detach-client

tmux new-session -s "🌈 vpn" \; \
    send-keys "$HOME/v2ray/v2ray" C-m \; \
    split-window -v \; \
    detach-client

tmux new-session -s "🦄 term" \; \
    send-keys "cd $HOME" C-m
