echo "HOME: ${HOME}"

# Symlinks all the dotfiles into your home directory
echo "Setting up symlinks to custom dotfiles"
echo ""

for FILE in `ls -A $PWD/dotfiles/`; do
    echo "Linking $PWD/dotfiles/$FILE to $HOME/$FILE ..."

    if [ -e "$PWD/dotfiles/$FILE" ]; then
        echo "$HOME/$FILE already exists, renaming it to $FILE.bak"

        if [ -e "$HOME/$FILE.bak" ]
        then
            rm -r "$HOME/$FILE.bak"
        fi

	echo "Deleting $HOME/$FILE.bak ..."
	mv $HOME/$FILE $HOME/$FILE.bak

	ll | grep $FILE
    fi
    ln -s $PWD/dotfiles/$FILE $HOME/$FILE
    echo ""

done
echo "Success!"
