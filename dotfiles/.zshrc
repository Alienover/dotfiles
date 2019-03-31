# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH # Path to your oh-my-zsh installation.
export ZSH="/Users/jiarong/.oh-my-zsh"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="powerlevel9k/powerlevel9k"
ZSH_THEME="astro"
# ZSH_THEME="ys"
DEFAULT_USER=edison

# command line 左邊想顯示的內容
# <= left prompt 設了 "dir"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(virtualenv dir vcs dir_writable newline status)

POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()


POWERLEVEL9K_MODE='nerdfont-complete'
POWERLEVEL9K_VCS_HIDE_TAGS=true

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
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

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
alias saturn="~/Documents/work/edison/Saturn"
alias titan="~/Documents/work/edison/Titan"
alias ops="~/Documents/work/edison/Ops"
alias utils="~/Documents/work/edison/Utils"
alias polaris="~/Documents/work/edison/Polaris"

# MySQL
alias mysql-start="brew services start mysql@5.6"
alias mysql-stop="brew services stop mysql@5.6"
alias mysql-restart="brew services restart mysql@5.6"
export PATH="/usr/local/opt/mysql@5.6/bin:/usr/local/bin:$PATH"

# Brew Services
alias brew-services="brew services list | grep"

alias tmn='tmux new -s '
alias tma='tmux attach -t '

# EDO Servers Login
alias edo_login="sh ~/Documents/work/Others/edo_login.sh"

# OpenVPN
alias openvpn="sudo /usr/local/Cellar/openvpn/2.4.6/sbin/openvpn"

# Auto Connect Edison VPN
alias edo_vpn="sudo expect ~/Documents/work/Others/vpnlogin.sh"

# V2ray proxy
alias v2ray="~/v2ray/v2ray"

# System SOCKS Proxy
alias socksproxy="~/scripts/socksproxy.sh"

# For neovim
alias vim="nvim"

# For zsh syntax-highlighting
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export DYLD_LIBRARY_PATH=/usr/local/include
export CPPFLAGS="-I/usr/local/include/snappy-c.h"
export CFLAGS="-I/usr/local/include/snappy-c.h"

TERM=xterm-256color-italic

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# For virtualenvwrapper
if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    export WORKON_HOME=$HOME/.virtualenvs
    source /usr/local/bin/virtualenvwrapper.sh
fi
export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
eval "$(pyenv init -)"
pyenv virtualenvwrapper_lazy

export PATH="$HOME/go/bin:$PATH"
