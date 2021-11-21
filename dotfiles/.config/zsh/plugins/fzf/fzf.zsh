# Place your plugin content here
source "$ZDOTDIR/zsh-functions.sh"

# FzF
function __load_fzf {
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
}

zsh_lazy_load fzf "__load_fzf"
