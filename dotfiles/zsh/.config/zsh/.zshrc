export GPG_TTY=$(tty)

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"
source "${ZDOTDIR}/zsh-functions.zsh"

# Add Powrlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

zsh_required=(
  # Load Customized color scheme
  zsh-colors # $ZDOTDIR/zsh-colors.sh

# Load alias
  zsh-alias # $ZDOTDIR/zsh-alias.sh
)

zsh_plugins=(
  # External
  zsh-users/zsh-syntax-highlighting

  # Personal - check $ZDOTDIR/plugins for more detail
  "history"
  completion
  fnm
  fzf
  nvim
  obsidian
  p10k
  tmux
  vi-mode
  mise
  virtualenvwrapper

  # Work
  edo-work
)

zsh_init 2>> /tmp/zsh-error.$(date +%F).log
