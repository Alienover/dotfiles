### Colorschemes
__tm_theme_bg="$GUI_BG_BLACK"
__tm_theme_light_fg="$GUI_PRIMARY"
__tm_theme_dark_fg="$GUI_BG_BLACK"

__tm_theme_session_bg="$GUI_PRIMARY"
__tm_theme_active_window_fg="$__tm_theme_session_bg"
__tm_theme_active_window_bg="$GUI_SECONDARY"
__tm_theme_inactive_window_fg="$__tm_theme_session_bg"
__tm_theme_inactive_window_bg="$GUI_BG_BLACK"
__tm_theme_host_bg="$GUI_PRIMARY"
__tm_theme_date_fg="$__tm_theme_host_bg"
__tm_theme_date_bg="$GUI_SECONDARY"
__tm_theme_border="$GUI_ACTIVE_TAB_FOREGROUND"

__tm_theme_window_mode_bg="$GUI_GREEN"
__tm_theme_match_bg="#$GUI_SECONDARY"
__tm_theme_current_match_bg="#$GUI_RED"

# separators
tm_separator_left_arrow=""
tm_separator_right_arrow=""

set -g status-left-length 32
set -g status-right-length 150
set -g status-interval 5

# set window-status-separator "$tm_separator_right_arrow"

# default statusbar colors
set-option -g status-fg $__tm_theme_bg
set-option -g status-bg $__tm_theme_bg

# default window title colors
set-window-option -g window-status-format " #[fg=$__tm_theme_inactive_window_fg] - #W #[fg=$__tm_theme_inactive_window_bg]$tm_separator_right_arrow"

# # active window title colors
set-window-option -g window-status-current-style bg=$__tm_theme_active_window_bg
set-window-option -g window-status-current-format "$tm_separator_right_arrow#[fg=$__tm_theme_active_window_fg,bold]  #W #[bg=$__tm_theme_bg,fg=$__tm_theme_active_window_bg]$tm_separator_right_arrow"

## pane border
set-option -g pane-border-style fg=$__tm_theme_border
set-option -g pane-active-border-style fg=$__tm_theme_border

## Prevent annoying renames
set-option -g allow-rename off

### Prompt
## Left
tm_session_name="#[bg=$__tm_theme_session_bg,fg=$__tm_theme_dark_fg,bold] #S #[bg=$__tm_theme_active_window_bg,fg=$__tm_theme_session_bg]$tm_separator_right_arrow#[fg=$__tm_theme_active_window_bg,bg=$__tm_theme_bg]$tm_separator_right_arrow"

## Right
# Current playing track
tm_tunes="#[fg=color3] #(osascript $HOME/.config/tmux/music.scpt) "
# tm_tunes="#[fg=$tm_color_music]#(osascript -l JavaScript ~/.config/tmux/tunes.js)"

tm_date="#[bg=$__tm_theme_bg,fg=$__tm_theme_date_bg]$tm_separator_left_arrow#[bg=$__tm_theme_date_bg,fg=$__tm_theme_date_fg] %R %d %b"
tm_host="#[bg=$__tm_theme_date_bg,fg=$__tm_theme_host_bg]$tm_separator_left_arrow#[bg=$__tm_theme_host_bg,fg=$__tm_theme_dark_fg,bold] #(whoami) "

tm_prompt_prefix="#[fg=$__tm_theme_session_bg]"
tm_prompt_suffix="#[bg=$__tm_theme_bg,fg=$__tm_theme_host_bg]"

tm_prompt_left="$tm_prompt_prefix$tm_session_name "
tm_prompt_right="$tm_tunes $tm_date $tm_host$tm_prompt_suffix"

set -g status-left $tm_prompt_left
set -g status-right $tm_prompt_right

## message text
set -gF  message-style "fg=$__tm_theme_light_fg,bg=$__tm_theme_bg"

### Clock
set -gwF clock-mode-colour "$__tm_theme_light_fg"
set -gwF mode-style fg=$__tm_theme_dark_fg,bg=$__tm_theme_window_mode_bg

### Copy
set -gwF copy-mode-match-style bg=$__tm_theme_match_bg
set -gwF copy-mode-current-match-style fg=$__tm_theme_dark_fg,bg=$__tm_theme_current_match_bg

### Border
set -gwF popup-border-lines rounded
set -gwF popup-border-style fg=$__tm_theme_light_fg
