# Refer to https://github.com/jeffreytse/zsh-vi-mode for more configuration details

# Disable the cursor style feature
ZVM_CURSOR_STYLE_ENABLED=false

# Changing the escape key to `jk`
ZVM_VI_ESCAPE_BINDKEY=jk

ZVM_VI_HIGHLIGHT_BACKGROUND=$GUI_GREEN
ZVM_VI_HIGHLIGHT_FOREGROUND=$GUI_SELECTION_FOREGROUND

# Always starting with insert mode for each command line
ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT

# Do the initialization when the script is sourced (i.e. Initialize instantly)
ZVM_INIT_MODE=sourcing

source "${0:A:h}/../../zsh-functions.zsh"
zinit light "jeffreytse/zsh-vi-mode"
