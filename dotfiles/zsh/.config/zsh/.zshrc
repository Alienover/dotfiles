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
. "${ZINIT_HOME}/zinit.zsh"
. "${ZDOTDIR}/zsh-functions.zsh"

# Add Powrlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

SHELL_CONFIG="$HOME/.config/shell"
# Load alias
[ -f "$SHELL_CONFIG/alias.sh" ] && . "$SHELL_CONFIG/alias.sh"
# Load Customized color scheme
[ -f "$SHELL_CONFIG/colors.sh" ] && . "$SHELL_CONFIG/colors.sh"

zsh_plugins=(
  # External
  zsh-users/zsh-syntax-highlighting

  # Personal - check $ZDOTDIR/plugins for more detail
  "history"
  completion
  fzf
  mise
  obsidian
  p10k
  tmux
  vi-mode

  # Work
  edo-work
)

zsh_init 2>> /tmp/zsh-error.$(date +%F).log
