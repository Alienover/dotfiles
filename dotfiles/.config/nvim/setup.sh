brew install nvim

# Install python and javascript extention for vim
type pip > /dev/null 2>&1
if [ $? -eq 0 ]; then
    pip install --upgrade pynvim
else
    echo "pynvim for python2 install failed"
fi

type pip3 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    pip3 install --upgrade pynvim
else
    echo "pynvim for python3 install failed"
fi

type yarn > /dev/null 2>&1
if [ $? -eq 0 ]; then
    yarn global install neovim
else
    echo "neovim for node install failed"
fi

# Setup the config files
source ../vim/vim.sh
source ../nvim/nvim.sh

# Setup the alias
echo '' >> ~/.zshrc
echo '# Alias for nvim => vim' >> ~/.zshrc
echo 'alias vim="nvim"' >> ~/.zshrc

mkdir -p ~/.config/nvim
ln -s $PWD/init.vim ~/.config/nvim/init.vim
