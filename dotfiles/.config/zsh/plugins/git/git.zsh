#! /bin/zsh
# function __git_prompt_git() {
#   GIT_OPTIONAL_LOCKS=0 command git "$@"
# }

# Checks if working tree is dirty
# function parse_git_dirty() {
#   local STATUS
#   local -a FLAGS
#   FLAGS=('--porcelain')
#   if [[ "$(__git_prompt_git config --get oh-my-zsh.hide-dirty)" != "1" ]]; then
#     if [[ "${DISABLE_UNTRACKED_FILES_DIRTY:-}" == "true" ]]; then
#       FLAGS+='--untracked-files=no'
#     fi
#     case "${GIT_STATUS_IGNORE_SUBMODULES:-}" in
#       git)
#         # let git decide (this respects per-repo config in .gitmodules)
#         ;;
#       *)
#         # if unset: ignore dirty submodules
#         # other values are passed to --ignore-submodules
#         FLAGS+="--ignore-submodules=${GIT_STATUS_IGNORE_SUBMODULES:-dirty}"
#         ;;
#     esac
#     STATUS=$(__git_prompt_git status ${FLAGS} 2> /dev/null | tail -1)
#   fi
#   if [[ -n $STATUS ]]; then
#     echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
#   else
#     echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
#   fi
# }

function parse_git_dirty() {
    if [[ -n $(git status -z 2> /dev/null) ]]; then
	echo "*"
    else
	echo ""
    fi
}

function __init_alias {
    alias gd="popup-diff"
    alias gl="popup-logs"
    alias gc="git checkout"
    alias gs="git status"
    alias gp="git pull"
    alias gp="git push origin"
}

__init_alias
