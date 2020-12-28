# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH # Path to your oh-my-zsh installation.
export ZSH="/Users/jiarong/.oh-my-zsh"

# Load Customized color scheme
source '/Users/jiarong/.dotfiles/.config/colors.sh'

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="astro"
# ZSH_THEME="ys"
# ZSH_THEME="materialshell"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  tmux
  zsh-autosuggestions
)
fpath=(/usr/local/share/zsh/site-functions $fpath)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Proxychains
alias proxychains="/usr/local/bin/proxychains4"

# Edison
alias agent8="~/Documents/work/agent8"
alias saturn="~/Documents/work/agent8/Saturn"
alias titan="~/Documents/work/agent8/Titan"
alias ops="~/Documents/work/agent8/Ops"
alias utils="~/Documents/work/agent8/Utils"
alias polaris="~/Documents/work/agent8/Polaris"

alias edo_login="sh ~/Documents/work/others/edo_login.sh"

# MySQL
alias mysql-start="brew services start mysql@5.6"
alias mysql-stop="brew services stop mysql@5.6"
alias mysql-restart="brew services restart mysql@5.6"
export PATH="/usr/local/opt/mysql@5.6/bin:/usr/local/bin:$PATH"

# Brew Services
alias brew-services="brew services list | grep"

# System SOCKS Proxy
alias socksproxy="~/src/socksproxy.sh"

# For neovim
alias vim="nvim"
alias vi="nvim"

# Git
alias gd="git diff"
alias gc="git checkout"
alias gs="git status"
alias gp="git pull"

# For zsh syntax-highlighting
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export DYLD_LIBRARY_PATH=/usr/local/include
export CPPFLAGS="-I/usr/local/include/snappy-c.h"
export CFLAGS="-I/usr/local/include/snappy-c.h"

export TERM="screen-256color"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# For virtualenvwrapper
if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    export WORKON_HOME=$HOME/.virtualenvs
    source /usr/local/bin/virtualenvwrapper.sh
fi
export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
eval "$(pyenv init -)"
pyenv virtualenvwrapper_lazy

# Go Path
export PATH="$HOME/go/bin:$PATH"
export GOBIN="$HOME/go/bin"

# Github CLI
export PATH="$HOME/.githubcli/bin:$PATH"

export LC_ALL=en_US.UTF-8

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

export PYENV_ROOT='/Users/jiarong/.pyenv'
export PATH="/usr/local/opt/ruby/bin:$PATH"

# Tmux switchy
alias sw="sh $HOME/.tmux_settings/tmux_switchy.sh"
