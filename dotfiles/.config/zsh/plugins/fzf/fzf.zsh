# Place your plugin content here

# Lazy load fzf
# source "$ZDOTDIR/zsh-functions.sh"
#
# function __load_fzf {
#     [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# }
#
# zsh_lazy_load fzf "__load_fzf"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# (EXPERIMENTAL) Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf "$@" --height 30% --reverse --preview 'tree -C {} | head -200' ;;
    export|unset) fzf "$@" --preview "eval 'echo \$'{}" ;;
    ssh)          fzf "$@" --preview 'dig {}' ;;
    *)            fzf "$@" ;;
  esac
}

export FZF_CTRL_T_COMMAND="fd --type f"
