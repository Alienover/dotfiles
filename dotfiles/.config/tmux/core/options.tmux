set -g history-limit 2000

# automatically renumber tmux windows
set -g renumber-windows on

# Activity Monitoring
setw -g monitor-activity off
set -g visual-activity off

# Rather than constraining window size to the maximum size of any client
# connected to the *session*, constrain window size to the maximum size of any
# client connected to *that window*. Much more reasonable.
setw -g aggressive-resize on

# make delay shorter
set -sg escape-time 0

set-option -g set-titles on
set-option -g set-titles-string "#T - #W"
# set-window-option -g automatic-rename on

# For compatity about neovim
set-option -g focus-events on

# make window/pane index start with 1
set -g base-index 1
setw -g pane-base-index 1

# enable mouse support for switching panes/windows
setw -g mouse on

# set vi mode for copy mode
setw -g mode-keys vi
