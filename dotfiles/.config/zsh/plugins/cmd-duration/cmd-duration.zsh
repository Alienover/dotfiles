# Refer to: https://github.com/tom-auger/cmdtime/blob/main/cmdtime.plugin.zsh
zmodload zsh/datetime

__cmd_current_time() {
  echo "$EPOCHREALTIME"
}

__cmd_duration_preexec() {
  __cmd_start_time=$(__cmd_current_time)
}

__cmd_duration_precmd() {
  unset CMD_DURATION

  if [ -n "$__cmd_start_time" ]; then
    # local end=$(__cmd_current_time)
    local duration=$(($(__cmd_current_time) - $__cmd_start_time))
    unset __cmd_start_time

    if [[ $duration -ge 1 ]]; then
      export CMD_DURATION=$duration
    fi
  fi
}

autoload -U add-zsh-hook
add-zsh-hook preexec __cmd_duration_preexec
add-zsh-hook precmd __cmd_duration_precmd
