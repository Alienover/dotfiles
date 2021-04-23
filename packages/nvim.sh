source "$PWD/utils.sh"

PLATFORM=$(uname | tr '[:upper:]' '[:lower:]')

_install_for_unix() {
    FILENAME="$1.tar.gz"
    BIN_FILE="$1/bin/nvim"
    URL="https://github.com/neovim/neovim/releases/latest/download/$FILENAME"

    if [ -e "$FILENAME" ]; then
        log_start "Deleting duplicated file..."
        rm -r "$FILENAME" || log_error
        log_success
    fi
    log_start "Downloading neovim from github..."
    wget -q "$URL" || log_error
    log_success
    log_start "Installing neovim..."
    tar xzf "$FILENAME" || log_error
    cp "$BIN_FILE" /usr/local/bin/nvim || log_error
    rm -r "$FILENAME" "$1" || log_error
    log_success
}

if [ "$PLATFORM" = "darwin" ]; then
    _install_for_unix "nvim-macos"
elif [ "$PLATFORM" = "linux" ]; then
    _install_for_unix "nvim-linux64"
fi

type mkvirtualenv > /dev/null 2>&1
if [ $? -eq 0 ]; then
    log_start "Installing pynvim for python2..."
    silent "mkvirtualenv neovim-py2 --python=\`which python2\`" || log_error
    silent "pip install --upgrade pynvim" || log_error
    silent "deactivate"
    log_success

    log_start "Installing pynvim for python3..."
    silent "mkvirtualenv neovim-py3 --python=\`which python3\`" || log_error
    silent "pip install --upgrad pynvim" || log_error
    silent "deactivate"
    log_success
fi

write_to_zshrc ""
write_to_zshrc "# Alias for nvim => vim"
write_to_zshrc "alias vim=\"nvim\""

NVIM_PATH="$HOME/.config/nvim"
mkdir -p "$NVIM_PATH"
echo "set runtimepath^=~/.vim runtimepath+=~/.vim/after" > "$NVIM_PATH/init.vim"
echo "let &packpath=&runtimepath" >> "$NVIM_PATH/init.vim"
echo "source ~/.vimrc" >> "$NVIM_PATH/init.vim"
