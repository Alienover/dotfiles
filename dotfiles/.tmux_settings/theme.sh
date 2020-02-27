#### COLOUR

tm_color_active=colour32
tm_color_inactive=colour241
tm_color_feature=colour206
tm_color_music=colour215
tm_active_border_color=colour240

tm_color_green_1="#98C379"
tm_color_green_2=colour29
tm_color_green_3=colour23

tm_color_grey_1="#ABB2BF"
tm_color_grey_2="#202020"

tm_color_black="#151515"

# separators
tm_separator_left_arrow=""
tm_separator_right_arrow=""

set -g status-left-length 32
set -g status-right-length 150
set -g status-interval 5

# default statusbar colors
set-option -g status-fg $tm_color_grey_1
set-option -g status-bg $tm_color_black

# default window title colors
set-window-option -g window-status-format " #I:#W "


# active window title colors
set-window-option -g window-status-current-style fg=$tm_color_green_1
set-window-option -g window-status-current-style bg=default
set-window-option -g window-status-current-format "#[bg=$tm_color_grey_2,fg=$tm_color_black]$tm_separator_right_arrow#[fg=$tm_color_green_1,bold] #I:#W #[bg=$tm_color_black,fg=$tm_color_grey_2]$tm_separator_right_arrow"

# pane border
set-option -g pane-border-style fg=$tm_color_inactive
set-option -g pane-active-border-style fg=$tm_active_border_color

# message text
set-option -g message-style bg=default
set-option -g message-style fg=$tm_color_active

# pane number display
set-option -g display-panes-active-colour $tm_color_active
set-option -g display-panes-colour $tm_color_inactive

# Prevent annoying renames
set-option -g allow-rename off

# clock
set-window-option -g clock-mode-colour $tm_color_active

# tm_tunes="#[fg=$tm_color_music]#(osascript ~/.tmux_settings/google_play_music.scpt | cut -c 1-50)"
tm_tunes="#[fg=$tm_color_music]#(osascript -l JavaScript ~/.tmux_settings/tunes.js)"

tm_date="#[bg=default,fg=$tm_color_grey_2]$tm_separator_left_arrow#[bg=$tm_color_grey_2,fg=$tm_color_grey_1] %R %d %b"
tm_host="#[fg=$tm_color_green_1]$tm_separator_left_arrow#[bg=$tm_color_green_1,fg=colour0,bold] #(whoami) "
tm_session_name="#[bg=$tm_color_green_1,fg=colour0,bold] #S #[bg=$tm_color_black,fg=$tm_color_green_1]$tm_separator_right_arrow"

set -g status-left $tm_session_name' '
set -g status-right $tm_tunes' '$tm_date' '$tm_host


# Tmux themes!
# source ~/.tmux_settings/magenta.sh
