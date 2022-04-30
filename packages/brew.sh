__brew_setup_success() {
    HOMEBREW_BIN=`which brew`

    if [[ $? -eq 0 ]]; then
        echo "Done! Homebrew located at $HOMEBREW_BIN"
    fi
}

__brew_setup() {
    echo "Choose what kind of action for Homebrew:"
    echo "\t 1 - Original installation"
    echo "\t 2 - Fully installation from gitee.com"
    echo "\t 3 - Simple installation from gitee.com"
    echo "\t r - Uninstall"
    echo  "(1/2/3/r): \c"; read option


    case "$option" in
        1)
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            __brew_setup_success
            exit 0
            ;;
        2)
            /bin/zsh -c "$(curl -fsSL https://gitee.com/cunkai/HomebrewCN/raw/master/Homebrew.sh)"
            __brew_setup_success
            exit 0
            ;;
        3)
            /bin/zsh -c "$(curl -fsSL https://gitee.com/cunkai/HomebrewCN/raw/master/Homebrew.sh)"
            __brew_setup_success
            exit 0
            ;;
        "r")
            /bin/zsh -c "$(curl -fsSL https://gitee.com/cunkai/HomebrewCN/raw/master/HomebrewUninstall.sh)"
            __brew_setup_success
            exit 0
            ;;
        *)
            clear
            echo 'Invalid option! Please try again...'
            ;;
    esac
}

while true; do
    __brew_setup
done
