# vim:ft=zsh ts=2 sw=2 sts=2
#
# agnoster's Theme - https://gist.github.com/3712874
# A Powerline-inspired theme for ZSH
#
# # README
#
# In order for this theme to render correctly, you will need a
# [Powerline-patched font](https://github.com/Lokaltog/powerline-fonts).
# Make sure you have a recent version: the code points that Powerline
# uses changed in 2012, and older versions will display incorrectly,
# in confusing ways.
#
# In addition, I recommend the
# [Solarized theme](https://github.com/altercation/solarized/) and, if you're
# using it on Mac OS X, [iTerm 2](https://iterm2.com/) over Terminal.app -
# it has significantly better color fidelity.
#
# If using with "light" variant of the Solarized color schema, set
# SOLARIZED_THEME variable to "light". If you don't specify, we'll assume
# you're using the "dark" variant.
#
# # Goals
#
# The aim of this theme is to only show you *relevant* information. Like most
# prompts, it will only show git information when in a git working directory.
# However, it goes a step further: everything from the current user and
# hostname to whether the last call exited with an error to whether background
# jobs are running in this shell will all be displayed automatically when
# appropriate.

### Segment drawing
# A few utility functions to make it easy and re-usable to draw segmented prompts
CURRENT_BG='NONE'
CURRENT_FG="$GUI_FOREGROUND"

# case ${SOLARIZED_THEME:-dark} in
#     light) CURRENT_FG=$GUI_FOREGROUND;;
#     *)     CURRENT_FG=$GUI_BLACK;;
# esac

### Colorschemes
# Preset
__THEME_LIGHT_FG="$GUI_FOREGROUND"
__THEME_DARK_FG="$GUI_BG_BLACK"
__THEME_LEFT_START_FG="$GUI_SECONDARY"
__THEME_START_BG="$GUI_BG_BLACK"
# Ultilities
__THEME_GIT_DIRTY_BG="$GUI_DARK_YELLOW"
__THEME_GIT_CLEAN_BG="$GUI_BLACK"
__THEME_DIR_BG="$GUI_PRIMARY"
__THEME_ENV_PY_BG="$GUI_SELECTION_BACKGROUND"
__THEME_ENV_NODE_BG="$GUI_GREEN"
__THEME_ENV_GO_BG="$GUI_CYAN"
__THEME_STATUS_BG="$GUI_SECONDARY"
__THEME_VI_BG="$GUI_PRIMARY"
__THEME_VI_NORMAL_BG="$GUI_GREEN"
__THEME_VI_VISUAL_BG="$GUI_ACTIVE_TAB_BACKGROUND"
__THEME_RUNTIME_BG="$GUI_SECONDARY"

typeset -g __THEME_MY_PROMPT_CHAR="$ "

# Special Powerline characters

() {
  local LC_ALL="" LC_CTYPE="en_US.UTF-8"
  # NOTE: This segment separator character is correct.  In 2012, Powerline changed
  # the code points they use for their special characters. This is the new code point.
  # If this is not working for you, you probably have an old version of the
  # Powerline-patched fonts installed. Download and install the new version.
  # Do not submit PRs to change this unless you have reviewed the Powerline code point
  # history and have new information.
  # This is defined using a Unicode escape sequence so it is unambiguously readable, regardless of
  # what font the user is viewing this source code in. Do not replace the
  # escape sequence with a single literal character.
  # Do not change this! Do not make it '\u2b80'; that is the old, wrong code point.
  SEGMENT_SEPARATOR=$'\ue0b0'
  SEGMENT_SEPARATOR_REV=""

  SEPARATOR=$SEGMENT_SEPARATOR
}

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

prompt_segment_rev() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    # echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR_REV%{$fg%} "
    echo -n "%{%K{$CURRENT_BG}%F{$1}%}$SEGMENT_SEPARATOR_REV%{$bg$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n "$3 "
}

prompt_start() {
  CURRENT_BG="$__THEME_START_BG"
}

# End the prompt, closing any open segments
prompt_end() {
  local separator
  [[ -n $1 ]] && separator="$1" || separator="$SEGMENT_SEPARATOR"

  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$separator"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

prompt_bold() {
  echo -n "%B"
}

prompt_bold_end() {
  echo -n "%b"
}

### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# Context: Public IP of the current machine
prompt_context() {
  if [[ -n "$SSH_CLIENT" ]]; then
    if [[ ! -f /tmp/.ip_address ]]; then
      curl -s ifconfig.me > /tmp/.ip_address
    fi

    local IP="$(cat /tmp/.ip_address)"

    echo -n "$IP"
  fi
}

# Git: branch/detached head, dirty status
prompt_git() {
  (( $+commands[git] )) || return
  if [[ "$(git config --get oh-my-zsh.hide-status 2>/dev/null)" = 1 ]]; then
    return
  fi
  local PL_BRANCH_CHAR
  () {
    local LC_ALL="" LC_CTYPE="en_US.UTF-8"
    PL_BRANCH_CHAR=$'\ue0a0'         # 
  }
  local ref dirty mode repo_path

  if [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]]; then
    repo_path=$(git rev-parse --git-dir 2>/dev/null)
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || \
    ref="◈ $(git describe --exact-match --tags HEAD 2> /dev/null)" || \
    ref="󱞫 $(git rev-parse --short HEAD 2> /dev/null)"
    if [[ -n $dirty ]]; then
      prompt_segment $__THEME_GIT_DIRTY_BG $__THEME_DARK_FG
    else
      prompt_segment $__THEME_GIT_CLEAN_BG $__THEME_LIGHT_FG
    fi

    if [[ -e "${repo_path}/BISECT_LOG" ]]; then
      mode=" <B>"
    elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
      mode=" >M<"
    elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
      mode=" >R>"
    fi

    setopt promptsubst
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' stagedstr '󰐕'
    zstyle ':vcs_info:*' unstagedstr '#'
    zstyle ':vcs_info:*' formats ' %u%c'
    zstyle ':vcs_info:*' actionformats ' %u%c'
    vcs_info
    echo -n "${ref/refs\/heads\//$PL_BRANCH_CHAR }${vcs_info_msg_0_%% }${mode}"
  fi
}

# Dir: current working directory
prompt_dir() {
  # Abbreviate the $PWD
  local current_dir="$(sed "s:\([^/\.]\)[^/]*/:\1/:g" <<< ${PWD/#$HOME/\~})"

  local context="$(prompt_context)"
  if [[ -n "$context" ]]; then
    current_dir="$context#$current_dir"
  fi
  # Font bold
  prompt_bold
  prompt_segment $__THEME_DIR_BG $__THEME_DARK_FG $current_dir
  prompt_bold_end
}

# Virtualenv: current working virtualenv
prompt_virtualenv() {
  prompt_bold
  prompt_segment_rev $__THEME_ENV_PY_BG $__THEME_DARK_FG "\ue73c `/usr/bin/basename $VIRTUAL_ENV`"
  prompt_bold_end
}

prompt_node() {
  prompt_bold
  prompt_segment_rev $__THEME_ENV_NODE_BG $__THEME_DARK_FG "\ue718 `node -v | sed 's/v//'`"
  prompt_bold_end
}

prompt_go() {
  prompt_bold
  prompt_segment_rev $__THEME_ENV_GO_BG $__THEME_DARK_FG "\ue724 `/usr/local/go/bin/go env GOVERSION | /usr/bin/sed 's/go//'`"
  prompt_bold_end
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  local -a symbols

  [[ -n ${VIM:-$NVIM} ]] && symbols="%{%F{$GUI_GREEN}%} %{%f%}"
  [[ $RETVAL -ne 0 ]] && symbols="%{%F{$GUI_RED}%}✖ %{%f%}"
  # [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"

  # Rainbow when all is well
  [[ -z "$symbols" ]] && symbols="🌈"

  prompt_segment $__THEME_STATUS_BG $__THEME_DARK_FG "$symbols"
}

prompt_jobs() {
  if [[ $(jobs -l | wc -l) -gt 0 ]]; then
    echo -n " %{%F{$GUI_CYAN}%}%{%f%} "
  fi
}

prompt_vi_mode() {
  local mode=""
  local bg="$__THEME_VI_BG"

  case $ZVM_MODE in
    $ZVM_MODE_NORMAL)
      mode="NORMAL"
      bg="$__THEME_VI_NORMAL_BG"
      # Something you want to do...
      ;;
    $ZVM_MODE_INSERT)
      mode="INSERT"
      # Something you want to do...
      ;;
    $ZVM_MODE_VISUAL)
      mode="VISUAL"
      bg="$__THEME_VI_VISUAL_BG"
      # Something you want to do...
      ;;
    $ZVM_MODE_VISUAL_LINE)
      mode="V-LINE"
      bg="$__THEME_VI_VISUAL_BG"
      # Something you want to do...
      ;;
    $ZVM_MODE_REPLACE)
      mode="REPLACE"
      bg="$__THEME_VI_VISUAL_BG"
      # Something you want to do...
      ;;
  esac

  if [[ ! -z "$mode" ]]; then
    prompt_bold
    prompt_segment_rev $bg $__THEME_DARK_FG $mode
    prompt_bold_end
  fi
}

prompt_runtime() {
  local function __runtime_format() {
    local hours=$(printf '%u' $(($1 / 3600)))
    local mins=$(printf '%u' $((($1 - hours * 3600) / 60)))
    local secs=$(printf "%.2f" $(($1 - 60 * mins - 3600 * hours)))
    if [[ ! "$hours" == "0" || ! "$mins" == "0" ]]; then
      secs=$(printf "%u" $(($1 - 60 * mins - 3600 * hours)))
    fi

    local output=""
    local function append() {
      if [[ ! "$1" == 0 ]]; then
        [[ -n $output ]] && output+=" "

        output+="$1$2"
      fi
    }

    append $hours "h"
    append $mins "m"
    append $secs "s"

    echo "$output"
  }

  local cmd_duration=$CMD_DURATION

  if [[ -n $cmd_duration && $cmd_runtime -ge 0 ]]; then
    local formatted=$(__runtime_format $cmd_duration)
    prompt_segment_rev $__THEME_RUNTIME_BG $__THEME_LIGHT_FG "${formatted}"
  fi
}

prompt_env() {
  local root=`git rev-parse --show-toplevel --quiet 2>/dev/null`

  if [[ -n $root ]]; then
    if [[ -f "./package.json" ]]; then
      prompt_node
      return 0
    fi

    if [[ -f "./go.mod" ]]; then
      # TODO: compare version in go.sum
      prompt_go
    fi

  fi

  local virtualenv_path="$VIRTUAL_ENV"
  if [[ -n $virtualenv_path && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
    prompt_virtualenv
  fi
}

prompt_prefix() {
  echo -n "%{%K{$CURRENT_BG}%F{$__THEME_LEFT_START_FG}%}%{%k%f%}"
}

prompt_suffix() {
  echo -n "%{%K%F{$CURRENT_BG}%}%{%k%f%}"
}

__my_prompt_length() {
  emulate -L zsh
  local -i COLUMNS=${2:-COLUMNS}
  local -i x y=${#1} m
  if (( y )); then
    while (( ${${(%):-$1%$y(l.1.0)}[-1]} )); do
      x=y
      (( y *= 2 ))
    done
    while (( y > x + 1 )); do
      (( m = x + (y - x) / 2 ))
      (( ${${(%):-$1%$m(l.x.y)}[-1]} = m ))
    done
  fi
  echo -n $x
}

__my_fill_line() {
  emulate -L zsh
  local -i left_len=$(__my_prompt_length $1)
  local -i right_len=$(__my_prompt_length $2 9999)
  local -i pad_len=$((COLUMNS - left_len - right_len - ${ZLE_RPROMPT_INDENT:-1}))
  if (( pad_len < 1 )); then
    # Not enough space for the right part. Drop it.
    echo -n $1
  else
    local pad=${(pl.$pad_len+1.. .)}  # pad_len spaces
    echo ${1}${pad}${2}
  fi
}

## Main prompt
__build_left_prompt() {
  RETVAL=$?
  prompt_prefix
  prompt_status
  prompt_dir
  prompt_git
  prompt_end
}

__build_right_prompt() {
  prompt_jobs
  prompt_start
  prompt_runtime
  prompt_env
  prompt_vi_mode
  prompt_suffix
}

__build_bottom_left_prompt() {
  echo "%{%F{$GUI_GREEN}%}$__THEME_MY_PROMPT_CHAR%{%f%}"
}

PROMPT='$(__my_fill_line "$(__build_left_prompt)" "$(__build_right_prompt)")$(__build_bottom_left_prompt)'

# build_prompt
