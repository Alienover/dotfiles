# Increase scrollback buffer size from 2000 to 50000 lines
set -g history-limit 50000

# automatically renumber tmux windows
set -g renumber-windows on

# Activity Monitoring
setw -g monitor-activity off
set -g visual-activity off

# Rather than constraining window size to the maximum size of any client
# connected to the *session*, constrain window size to the maximum size of any
# client connected to *that window*. Much more reasonable.
setw -g aggressive-resize on

# Address vim mode switching delay (http://superuser.com/a/252717/65504)
set -sg escape-time 0

# Disable title
set -g set-titles off

# For compatity about neovim
set -g focus-events on

# make window/pane index start with 1
set -g base-index 1
setw -g pane-base-index 1

# enable mouse support for switching panes/windows
setw -g mouse on

# set vi mode for copy mode
setw -g mode-keys vi

# Increase tmux messages display duration from 750ms to 4s
set -g display-time 4000

## Prevent annoying renames
set-option -g allow-rename off

set -g allow-passthrough on
set -ga update-environment TERM
set -ga update-environment TERM_PROGRAM

set-environment -g TMUX_PLUGIN_MANAGER_PATH "~/.tmux"
