source "$PWD/utils.sh"

log_start "Installing homebrew..."
silent "curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh" || log_error
log_success
