init_paths() {
    local MYSQL_CLIENT_BIN="/usr/local/opt/mysql-client/bin"

    local YARN_BIN="$HOME/.yarn/bin"

    local YARN_MODULES_BIN="$HOME/.config/yarn/global/node_modules/.bin"

    local VS_CODE_BIN="/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

    # Removed
    local RUBY_BIN="/usr/local/opt/ruby/bin"

    export PATH="$PATH:$MYSQL_CLIENT_BIN:$YARN_BIN:$YARN_MODULES_BIN:$VS_CODE_BIN:$PYENV_ROOT:$GOBIN"
}

init_paths
