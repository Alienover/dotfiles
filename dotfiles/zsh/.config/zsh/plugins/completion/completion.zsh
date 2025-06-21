autoload -Uz compinit

zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# suggest case insensitive e.g.: cd docu -> cd Documents
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompcache"

zmodload zsh/complist

# Include hidden files
_comp_options+=(globdots)

compinit -d $ZSH_COMPDUMP
