source "$PWD/utils.sh"

log_start "Installing vim-plug from github..."
silent "curl -Lso ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" || log_error
log_success
