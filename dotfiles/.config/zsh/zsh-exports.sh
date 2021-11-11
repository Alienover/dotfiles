export LC_ALL=en_US.UTF-8

export DYLD_LIBRARY_PATH=/usr/local/include
export CPPFLAGS="-I/usr/local/include/snappy-c.h"
export CFLAGS="-I/usr/local/include/snappy-c.h"

# ZSH caches and histories
export HISTFILE="${XDG_CACHE_HOME:-$HOME/.cche}/zsh/.zsh_history"
export ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompdump"

# Go Path
export GOBIN="$HOME/go/bin"

# Pyenv Path
export PYENV_ROOT="$HOME/.pyenv"

init_paths() {
    local MYSQL_CLIENT_BIN="/usr/local/opt/mysql-client/bin"

    local YARN_BIN="$HOME/.yarn/bin"

    local VS_CODE_BIN="/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

    local PYENV_BIN="$PYENV_ROOT/shims"

    # Removed
    local RUBY_BIN="/usr/local/opt/ruby/bin"

    export PATH="$MYSQL_CLIENT_BIN:$YARN_BIN:$VS_CODE_BIN:$GOBIN:$PYENV_BIN:$PATH"
}

init_paths

# zsh-vi-mode config
export ZVM_CURSOR_STYLE_ENABLED=false

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Perl
# eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"

# For virtualenvwrapper
if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    export WORKON_HOME=$HOME/.virtualenvs
    source /usr/local/bin/virtualenvwrapper.sh
fi
export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
export VIRTUAL_ENV_DISABLE_PROMPT='true'

# Lazy load pyenv
# Refer to: https://github.com/davidparsson/zsh-pyenv-lazy/blob/master/pyenv-lazy.plugin.zsh
function pyenv() {
    unset -f pyenv
    eval "$(command pyenv init -)"
    if [[ -n "${ZSH_PYENV_LAZY_VIRTUALENV}" ]]; then
	eval "$(command pyenv virtualenv-init -)"
    fi
    pyenv $@
}

export GO_PROJECTS_PATH=("$HOME/Documents/work/agent8/Rigel")
