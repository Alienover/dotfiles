#! /usr/bin/env sh

alias dot="cd $HOME/src/dotfiles"

if command -v nvim >/dev/null 2>&1; then
  alias vim="nvim"
fi

if command -v eza >/dev/null 2>&1; then
  alias ls="eza"
  alias ll="eza -alh --sort=type"
  alias tree="eza --tree"
else
  alias ls="ls --color=always"
  alias ll="ls -lh"
fi

if command -v bat >/dev/null 2>&1; then
  alias cat="$(command -v bat)"
fi

if command -v git >/dev/null 2>&1; then
  alias gd="fzf-git-diff"
  alias gl="fzf-git-logs"
  alias gc="git checkout"
  alias gs="git status"
fi

if [ -x "$HOME/.local/bin/tmux-preview" ]; then
  alias sw="tmux-switchy"
fi
