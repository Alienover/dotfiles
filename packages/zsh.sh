# Install zsh by homebrew
brew install zsh

# Replace bash by zsh in default
sudo sh -c "echo $(which zsh) >> /etc/shells" 
chsh -s $(which zsh)
