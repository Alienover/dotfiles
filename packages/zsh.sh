# source "$PWD/utils.sh"
#
# log_start "Installing zsh by homebrew..."
# silent "brew install zsh" || log_error
# log_success
#
# log_start "Replacing bash by zsh in default..."
# sudo sh -c "echo $(which zsh) >> /etc/shells"  || log_error
# chsh -s $(which zsh) || log_error
# log_success
#
# reload_shell
#
__zsh_setup() {
    echo "Choose what kind of action for zsh:"
    echo "\t 1 - Install"
    echo "\t 2 - Replace bash"
    echo "(1/2): \c"; read option

    case "$option" in
        1)
            brew install zsh
            exit 0
            ;;
        2)
            sudo sh -c "echo $(which zsh) >> /etc/shells"
            chsh -s $(which zsh)
            exit 0
            ;;
        *)
            clear
            echo 'Invalid option! Please try again...'
            ;;
    esac
}

while true; do
    __zsh_setup
done
