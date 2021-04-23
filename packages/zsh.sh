source "$PWD/utils.sh"

log_start "Installing zsh by homebrew..."
silent "brew install zsh" || log_error
log_success

log_start "Replacing bash by zsh in default..."
sudo sh -c "echo $(which zsh) >> /etc/shells"  || log_error
chsh -s $(which zsh) || log_error
log_success

reload_shell
