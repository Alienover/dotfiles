#! /bin/zsh

typeset -g __TP_NEWLINE=""

__TP_ORIGINAL_PROMPT="$PROMPT"

__tp_set_original_prompt() {
  PROMPT="${__TP_NEWLINE}${__TP_ORIGINAL_PROMPT}"
}

__tp_set_shorten_prompt() {
  local icon=">"
  local color="$GUI_GREEN"

  if [[ $PROMPT != *$icon* ]]; then
    PROMPT="${__TP_NEWLINE}%{%F{${color}}%}$icon %{%f%}"
    zle reset-prompt

    __TP_NEWLINE=$'\n'
  fi
}

__tp_set_prompt_on_trap() {
  __tp_set_shorten_prompt  # for last prompt
  __tp_set_original_prompt # for current prompt
}

autoload -U add-zsh-hook
add-zsh-hook precmd __tp_set_original_prompt

zle-line-finish() { __tp_set_shorten_prompt }
zle -N zle-line-finish

trap '__tp_set_prompt_on_trap; return 130' INT

clear-screen() {
  __TP_NEWLINE=""
  __tp_set_original_prompt
  zle .clear-screen
}

zle -N clear-screen
