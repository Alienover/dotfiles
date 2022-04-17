# Proxychains
alias proxychains="/usr/local/bin/proxychains4"

# System SOCKS Proxy
alias socksproxy="${HOME}/src/socksproxy.sh"

# For neovim
alias nvim="/usr/local/Cellar/neovim/nightly/bin/nvim"
alias vim="/usr/local/bin/nvim"
alias vi="/usr/local/bin/nvim"

# Git
alias gd="git diff"
alias gc="git checkout"
alias gs="git status"
alias gp="git pull"
alias gp="git push origin"

# Directories
alias ls="ls -G"
alias ll="ls -lh"

# alias -g ..='cd ..'
# alias -g ...='cd ../..'

alias goproxy="GOPROXY=https://goproxy.cn,direct go"

init_config_alias() {
    local MY_CONFIG_DIR="$HOME/.config"

    # Tmux switchy
    alias sw="sh $MY_CONFIG_DIR/tmux/tmux_switchy.sh"
}

# -- Work
init_work_alias() {
    local MY_WORK_DIR="$HOME/Documents/work"

    # Edison
    export EDISON_REPO_DIR="$MY_WORK_DIR/agent8"

    alias agent8="cd $EDISON_REPO_DIR"
    alias ops="cd $EDISON_REPO_DIR/Ops"
    alias titan="cd $EDISON_REPO_DIR/Titan"
    alias rigel="cd $EDISON_REPO_DIR/Rigel"
    alias utils="cd $EDISON_REPO_DIR/Utils"
    alias saturn="cd $EDISON_REPO_DIR/Saturn"
    alias polaris="cd $EDISON_REPO_DIR/Polaris"

    alias edo_login="sh $MY_WORK_DIR/others/edo_login.sh"
}

init_work_alias
init_config_alias
