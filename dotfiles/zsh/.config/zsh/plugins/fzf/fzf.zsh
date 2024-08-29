# Place your plugin content here

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Options to fzf command
export FZF_DEFAULT_OPTS="--height 30% --reverse \
--color=bg+:$GUI_BACKGROUND,bg:$GUI_BG_BLACK,spinner:$GUI_CURSOR_GREY,hl:$GUI_RED \
--color=fg:$GUI_GUTTER_FG_GREY,header:$GUI_RED,info:$GUI_ACTIVE_TAB_BACKGROUND,pointer:$GUI_DARK_YELLOW \
--color=marker:$GUI_RED,fg+:$GUI_DARK_YELLOW,prompt:$GUI_ACTIVE_TAB_BACKGROUND,hl+:$GUI_RED"

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# (EXPERIMENTAL) Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  local default_preview_cmd="if file {} | grep -E 'json|text'
    then
      bat --color=always {}
    elif file {} | grep directory
    then
      tree -C {} | head -200
    else
      file -b {}
    fi"

  case "$command" in
    cd)           fzf "$@" --height 30% --reverse --preview 'tree -C {} | head -200' ;;
    export|unset) fzf "$@" --preview "eval 'echo \$'{}" ;;
    ssh)          fzf "$@" --preview 'dig {}' ;;
    *)            fzf --preview "$default_preview_cmd" "$@" ;;
  esac
}

export FZF_CTRL_T_COMMAND="fd --type f"
