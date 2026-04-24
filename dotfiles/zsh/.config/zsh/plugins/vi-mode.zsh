# vi mode — Use zsh's built-in ZLE vi keymap instead of jeffreytse/zsh-vi-mode.

typeset -g VI_SELECT_BACKGROUND=${VI_SELECT_BACKGROUND:-$GUI_GREEN}
typeset -g VI_SELECT_FOREGROUND=${VI_SELECT_FOREGROUND:-$GUI_SELECTION_FOREGROUND}

bindkey -v

zle_highlight=("region:bg=$VI_SELECT_BACKGROUND,fg=$VI_SELECT_FOREGROUND")

# allow vv to edit the command line (standard behaviour)
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'vv' edit-command-line

# allow ctrl-p, ctrl-n for navigate history (standard behaviour)
bindkey '^P' up-history
bindkey '^N' down-history

# allow ctrl-a and ctrl-e to move to beginning/end of line
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
