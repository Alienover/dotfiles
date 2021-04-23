log_start() {
    echo -n "$@"
}

log_error() {
    echo -e "\t Failed!"
    exit 1
}

log_success() {
    echo -e "\t OK!"
}

reload_shell() {
    exec "$SHELL"
}

_PLATFORM=$(uname | tr '[:upper:]' '[:lower:]')

is_macos() {
    if [ "$_PLATFORM" = 'darwin' ]; then
        exit 0
    else
        exit 1
    fi
}

is_linux() {
    if [ "$_PLATFORM" = 'linux' ]; then
        exit 0
    else
        exit 1
    fi
}

silent() {
    eval "$@" &> /dev/null
}

write_to_zshrc() {
    echo "$@" >> "$HOME/.zshrc"
}
