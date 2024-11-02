# Place your plugin content here
source "$ZDOTDIR/zsh-functions.zsh"

export VIRTUALENVWRAPPER_HOOK_DIR="$HOME/.virtualenvs"

function __init_env {
  # Pyenv Path
  export PYENV_ROOT="$HOME/.pyenv"

  local PYENV_BIN="$PYENV_ROOT/shims"

  export PATH="$PYENV_BIN:$PATH"
}

# pyenv
# Refer to: https://github.com/davidparsson/zsh-pyenv-lazy/blob/master/pyenv-lazy.plugin.zsh
function __load_pyenv {
  eval "$(command pyenv init -)"
  if [[ -n "${ZSH_PYENV_LAZY_VIRTUALENV}" ]]; then
    eval "$(command pyenv virtualenv-init -)"
  fi
}

# virtualenv
function __load_virtualenv {
  # For virtualenvwrapper
  pyenv virtualenvwrapper_lazy

  export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
  export VIRTUAL_ENV_DISABLE_PROMPT='true'
}

__init_env

# Commands
zsh_lazy_load pyenv "__load_pyenv"
zsh_lazy_load workon "__load_virtualenv"
zsh_lazy_load lsvirtualenv "__load_virtualenv"
zsh_lazy_load allvirtualenv "__load_virtualenv"
