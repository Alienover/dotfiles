#! /bin/bash
CHECK_MARK="\033[0;32m\033[0m"

DOT_DIR="$PWD/dotfiles"
echo "HOME: ${HOME}"
echo "DOT DIR: $DOT_DIR"

# Symlinks all the dotfiles into your home directory
echo "\nSetting up symlinks to custom dotfiles ...\n"

function create_link() {
    local source="$1"
    local target="$2"
    local source_file=`echo $source | sed "s|$PWD|.|"`
    local target_file=`echo $target | sed "s|$HOME|~|"`

    echo "\033[0;90m\c"

    if [[ -e "$target" ]]; then
        echo "$target_file already exists, renaming it to $target_file.bak \c"

        if [[ -e "$target.bak" ]]; then
            rm -r "$target.bak"
        fi

	mv $target $target.bak
    fi
    ln -s $source $target

    echo "\r\033[K\c" 
    echo "$CHECK_MARK \033[0;90m `printf "%-35s->" $source_file` \t$target_file \033[0m"
}

for FILE in `ls -A $DOT_DIR`; do
    if [[ $FILE == ".config" ]]; then
        for FOLDER in `ls -A $DOT_DIR/$FILE`; do
            if [[ -d "$DOT_DIR/$FILE/$FOLDER" ]]; then
                create_link "$DOT_DIR/$FILE/$FOLDER" "$HOME/$FILE/$FOLDER"
            fi
        done
    else
        create_link "$DOT_DIR/$FILE" "$HOME/$FILE"
    fi
done
echo "\nDone!"
