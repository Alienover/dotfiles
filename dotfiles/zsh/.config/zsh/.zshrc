# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

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
  # Paths
  zsh-exports # $ZDOTDIR/zsh-exports.sh

  # Load Customized color scheme
  zsh-colors # $ZDOTDIR/zsh-colors.sh

# Load alias
  zsh-alias # $ZDOTDIR/zsh-alias.sh
)

zsh_plugins=(
  # External
  zsh-users/zsh-syntax-highlighting
  zsh-users/zsh-autosuggestions
  zsh-users/zsh-completions
  Aloxaf/fzf-tab

  # Personal - check $ZDOTDIR/plugins for more detail
  "history"
  completion
  brew
  asdf
  fnm
  fzf
  git
  go
  pyenv
  tmux
  nvim
  obsidian
  yazi
  ghq
  p10k

  # Work
  edo-work
)

zsh_init 2>> /tmp/zsh-error.$(date +%F).log
