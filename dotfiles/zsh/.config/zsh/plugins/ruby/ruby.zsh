#! /bin/env zsh

source "$ZDOTDIR/zsh-functions.zsh"

export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

function __load_rbenv {
  eval "$(rbenv init - --no-rehash zsh)"
}


zsh_lazy_load rbenv "__load_rbenv"
