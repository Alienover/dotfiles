# completion — Initialise compinit with cached dump, case-insensitive matching,
# and load zsh-completions + fzf-tab via zinit for richer, fzf-driven menus.

export ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/.zcompdump"

autoload -Uz compinit

zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:*' use-fzf-default-opts yes

zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# suggest case insensitive e.g.: cd docu -> cd Documents
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompcache"

zmodload zsh/complist

# Include hidden files
_comp_options+=(globdots)

compinit -d $ZSH_COMPDUMP

zinit ice blockf wait lucid depth=1
zinit light "zsh-users/zsh-completions"

zinit ice wait lucid depth=1
zinit light "Aloxaf/fzf-tab"
