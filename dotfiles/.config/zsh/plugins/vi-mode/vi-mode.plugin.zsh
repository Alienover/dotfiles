#! /bin/zsh

# Refer to https://github.com/jeffreytse/zsh-vi-mode for more configuration details

# Disable the cursor style feature
ZVM_CURSOR_STYLE_ENABLED=false

# Changing the escape key to `jk`
ZVM_VI_ESCAPE_BINDKEY=jk

# Changing the surround keybinding mode
ZVM_VI_SURROUND_BINDKEY=s-prefix

ZVM_VI_HIGHLIGHT_BACKGROUND=$GUI_GREEN
ZVM_VI_HIGHLIGHT_FOREGROUND=$GUI_SELECTION_FOREGROUND

ZVM_INIT_MODE=sourcing

source "${0:A:h}/../../zsh-functions.sh"
zsh_add_plugin "jeffreytse/zsh-vi-mode"
