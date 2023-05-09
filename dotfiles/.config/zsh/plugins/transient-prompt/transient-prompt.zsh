#! /bin/zsh

set-long-prompt() { PROMPT='%~%# ' }
precmd_functions=(set-long-prompt)

set-short-prompt() {
  if [[ $PROMPT != '%# ' ]]; then
    PROMPT='%# '
    zle .reset-prompt
  fi
}

zle-line-finish() { set-short-prompt }
zle -N zle-line-finish

trap 'set-short-prompt; return 130' INT
