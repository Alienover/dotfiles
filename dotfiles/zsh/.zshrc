# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Bootstrap zinit
ZINIT_HOME="${XDG_DATA_HOME}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
. "${ZINIT_HOME}/zinit.zsh"

# Powerlevel10k
zinit ice atload=". $HOME/.p10k.zsh" depth=1
zinit load romkatv/powerlevel10k

# Shared shell config (aliases + GUI_* color palette)
[ -f "$HOME/.config/shell/alias.sh" ]  && . "$HOME/.config/shell/alias.sh"
[ -f "$HOME/.config/shell/colors.sh" ] && . "$HOME/.config/shell/colors.sh"

# Local plugins — sourced directly, in dependency order
ZSH_DIR="${XDG_CONFIG_HOME}/zsh"
for plugin in history completion fzf mise obsidian vi-mode edo-work; do
  source "$ZSH_DIR/plugins/$plugin.zsh"
done

# External plugins (deferred)
zinit ice wait lucid depth=1
zinit light zsh-users/zsh-syntax-highlighting
