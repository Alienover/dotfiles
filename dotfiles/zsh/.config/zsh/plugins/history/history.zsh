export HISTSIZE=10000
export HISTFILE=${XDG_CACHE_HOME}/zsh/.zsh_history
export HISTORY_IGNORE="(cd|cd -|cd ..|pwd|ls|exit|)"
export SAVEHIST=$HISTSIZE
export HISTDUP=erase

setopt EXTENDED_HISTORY 
setopt APPEND_HISTORY 
setopt SHARE_HISTORY 
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
