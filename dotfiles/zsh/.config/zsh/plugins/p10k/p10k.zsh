# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

function prompt_devpod() {
  if [[  -z "$DEVPOD_WORKSPACE_ID"  ]]; then
    return
  fi

  p10k segment -f grey -t "($DEVPOD_WORKSPACE_ID)"
}
