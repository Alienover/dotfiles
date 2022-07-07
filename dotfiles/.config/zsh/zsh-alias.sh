# Proxychains
alias proxychains="/opt/homebrew/bin/proxychains4"

# For neovim
alias vim="/opt/homebrew/Cellar/neovim/nightly/bin/nvim"
# alias vim="nvim"
# alias vi="/usr/local/bin/nvim"

# Directories
alias ls="ls -G"
alias ll="ls -lh"

alias goproxy="GOPROXY=https://goproxy.cn,direct go"

init_config_alias() {
    local MY_CONFIG_DIR="$HOME/.config"

    # Tmux switchy
    alias sw="sh $MY_CONFIG_DIR/tmux/tmux_switchy.sh"
}

init_config_alias
