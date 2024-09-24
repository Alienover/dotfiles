#! /usr/bin/env zsh

source "$ZDOTDIR/zsh-functions.sh"

# INFO: Set terminal theme
zsh_theme="agnoster"

# INFO: Set required scripts before initializing
zsh_required=(
  # Paths
  zsh-exports # $ZDOTDIR/zsh-exports.sh

  # Load Customized color scheme
  zsh-colors # $ZDOTDIR/zsh-colors.sh

# Load alias
  zsh-alias # $ZDOTDIR/zsh-alias.sh
)

# INFO: Plugins
# - External  - load from $HOME/.zsh_plugins, otherwise download it from github.com
# - Personal  - load from $ZDOTDIR/plugins
# - Work      - load from $ZDOTDIR/plugins, for work preferences
zsh_plugins=(
  # External
  zsh-users/zsh-autosuggestions
  zsh-users/zsh-syntax-highlighting

  # Personal - check $ZDOTDIR/plugins for more detail
  brew
  cmd-duration
  completion
  fnm
  fzf
  git
  go
  pyenv
  tmux
  nvim
  vi-mode
  transient-prompt
  obsidian
  yazi
  ruby

  # Work
  edo-work
)

zsh_init 2>> /tmp/zsh-error.$(date +%F).log
