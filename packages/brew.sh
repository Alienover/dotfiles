echo "Choose what kind of action for Homebrew:"
echo "\t 1 - Original installation"
echo "\t 2 - Fully installation from gitee.com"
echo "\t 3 - Simple installation from gitee.com"
echo "\t r - Uninstall"
echo  "(1/2/3/r): \c"; read option

case "$option" in
    1)
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        ;;
    2)
        /bin/zsh -c "$(curl -fsSL https://gitee.com/cunkai/HomebrewCN/raw/master/Homebrew.sh)"
        ;;
    3)
        /bin/zsh -c "$(curl -fsSL https://gitee.com/cunkai/HomebrewCN/raw/master/Homebrew.sh)"
        ;;
    "r")
        /bin/zsh -c "$(curl -fsSL https://gitee.com/cunkai/HomebrewCN/raw/master/HomebrewUninstall.sh)"
        ;;
    *)
        echo 'Invalid option! Please try again...'
        exit 1
	;;
esac

HOMEBREW_BIN=`which brew`

if [[ $? -eq 0 ]]; then
    echo "Done! Homebrew located at $HOMEBREW_BIN"

    # Install the Apple app store command line tool
    brew install mas

    echo "Completed! Reopen the terminal to reload the related config."
fi
