#### COLOUR

tm_color_active=colour32
tm_color_feature=colour206
tm_color_music="$GUI_DARK_YELLOW"
tm_active_border_color=colour240

tm_color_inactive_bg="$GUI_INACTIVE_TAB_BACKGROUND"
tm_color_inactive_fg="$GUI_ACTIVE_TAB_BACKGROUND"
tm_color_primary="$GUI_ACTIVE_TAB_BACKGROUND"
tm_color_white="$GUI_FOREGROUND"
tm_color_grey="$GUI_SECONDARY"

tm_color_black="$GUI_ACTIVE_TAB_FOREGROUND"

# separators
tm_separator_left_arrow=""
tm_separator_right_arrow=""

set -g status-left-length 32
set -g status-right-length 150
set -g status-interval 5

# default statusbar colors
set-option -g status-fg $tm_color_primary
set-option -g status-bg $tm_color_black

# default window title colors
set-window-option -g window-status-format "#[bg=$tm_color_black,fg=$tm_color_black]$tm_separator_right_arrow#[fg=$tm_color_white] - #W #[bg=$tm_color_black,fg=$tm_color_black]$tm_separator_right_arrow"

# active window title colors
# set-window-option -g window-status-current-style fg=$tm_color_grey
set-window-option -g window-status-current-style bg=$tm_color_grey
set-window-option -g window-status-current-format "#[bg=$tm_color_grey,fg=$tm_color_black]$tm_separator_right_arrow#[fg=$tm_color_primary,bold] * #W #[bg=$tm_color_black,fg=$tm_color_grey]$tm_separator_right_arrow"

# pane border
set-option -g pane-border-style fg=$tm_color_inactive_bg
set-option -g pane-active-border-style fg=$tm_color_inactive_bg

# Prevent annoying renames
set-option -g allow-rename off

# Current playing track
# tm_tunes="#[fg=$tm_color_music]#(osascript ~/.tmux_settings/google_play_music.scpt | cut -c 1-50)"
tm_tunes="#[fg=$tm_color_music]#(osascript -l JavaScript ~/.config/tmux/tunes.js)"

tm_date="#[bg=$tm_color_black,fg=$tm_color_grey]$tm_separator_left_arrow#[bg=$tm_color_grey,fg=$tm_color_inactive_fg] %R %d %b"
tm_host="#[bg=$tm_color_grey,fg=$tm_color_primary,bold]$tm_separator_left_arrow#[bg=$tm_color_primary,fg=colour0,bold] #(whoami) "
tm_session_name="#[bg=$tm_color_primary,fg=colour0,bold] #S #[bg=$tm_color_grey,fg=$tm_color_primary]$tm_separator_right_arrow#[bg=$tm_color_black,fg=$tm_color_grey]$tm_separator_right_arrow"

set -g status-left $tm_session_name' '
set -g status-right $tm_tunes' '$tm_date' '$tm_host

# message text
set -gF  message-style "fg=$tm_color_primary,bg=$tm_color_black"

# Pane number display
set -gF  display-panes-active-colour "$tm_color_primary"
set -gF  display-panes-colour "$tm_color_grey"

# Clock
set -gwF clock-mode-colour "$tm_color_primary"
set -gwF mode-style "fg=colour0,bg=$tm_color_primary"
