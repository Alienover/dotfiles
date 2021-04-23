source "$PWD/utils.sh"

log_start "Installing node versions management..."
silent "curl -Ls https://git.io/n-install | bash -s -- -y lts" || log_error
log_success

reload_shell
