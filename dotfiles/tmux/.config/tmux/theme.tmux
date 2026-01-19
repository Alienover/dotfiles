# === Color schemas ===
BG="$GUI_BG_BLACK"
LIGHT_FG="$GUI_PRIMARY"
DARK_FG="$GUI_BG_BLACK"

SESSION_BG="$GUI_PRIMARY"
WINDOW_FG="${SESSION_BG}"
ACTIVE_WINDOW_BG="$GUI_BLACK"
INACTIVE_WINDOW_BG="$GUI_BG_BLACK"
HOST_BG="$GUI_PRIMARY"
DATE_FG="${HOST_BG}"
DATE_BG="$GUI_BLACK"
BORDER="$GUI_BLACK"

WINDOW_MODE_BG="$GUI_GREEN"
WINDOW_CURSOR_FG="$GUI_PRIMARY"
MATCH_BG="#$GUI_SECONDARY"
CURRENT_MATCH_BG="#$GUI_RED"

# === Separators ===
HALF_ROUND_OPEN=""
HALF_ROUND_CLOSE=""

TRIANGLE_OPEN=""
TRIANGLE_CLOSE=""

ZOOM_IN="#(printf ' 󰲏 ')"

HALF_BLOCK_SEP="\
#[fg=${WINDOW_CURSOR_FG},bg=${BG}]\
#(printf '\u2595')\
#[bg=${ACTIVE_WINDOW_BG}]\
#(printf '\u258F')\
#[fg=default]\
"

## Status Content Lenth
set -g status-left-length 32
set -g status-right-length 150

## Refresh frequency
set -g status-interval 5

## Default statusbar styling
set-option -g status-style bg=${BG},fg=${DARK_FG}
set-option -g window-status-style bg=${BG},fg=${WINDOW_FG}
set-option -g window-status-current-style bg=${ACTIVE_WINDOW_BG},fg=${WINDOW_FG}
set-option -g window-status-separator ""

## Border styling
set -gwF popup-border-lines rounded
set -gwF popup-border-style fg=${BORDER}
set-option -g pane-border-style fg=${BORDER}
set-option -g pane-active-border-style fg=${BORDER}

## Message text
set -gF message-style fg=${LIGHT_FG},bg=${BG}

## Clock
set -gwF clock-mode-colour ${LIGHT_FG}
set -gwF mode-style fg=${DARK_FG},bg=${WINDOW_MODE_BG}

## Copy
set -gwF copy-mode-match-style bg=${MATCH_BG}
set -gwF copy-mode-current-match-style fg=${DARK_FG},bg=${CURRENT_MATCH_BG}

# === Window Title ===

## Define winddow format
tm_window="#[fg=default]  #W  "
tm_active_window=" #W  "

set-window-option -g window-status-format "\
#[fg=${BG}]${TRIANGLE_CLOSE} \
${tm_window}\
#[fg=${BG}]${TRIANGLE_CLOSE}\
"

set-window-option -g window-status-current-format "\
${HALF_BLOCK_SEP}\
${tm_active_window}\
#[fg=${ACTIVE_WINDOW_BG}]${TRIANGLE_CLOSE}\
"

# === Prompt ===
## Left Components
tm_session_name="#[bg=${SESSION_BG},fg=${DARK_FG},bold] #S "
tm_zoom_status="#{?window_zoomed_flag,${ZOOM_IN}, }"

## Right Components
### Current playing track
tm_playing="#[fg=color3]#(osascript $XDG_CONFIG_HOME/tmux/now-playing.scpt)"

tm_date="#[bg=default,fg=${DATE_BG}]${TRIANGLE_OPEN}#[bg=${DATE_BG},fg=${DATE_FG}] %b %d %R "
tm_host="#[bg=${DATE_BG},fg=${HOST_BG}]${TRIANGLE_OPEN}#[bg=${HOST_BG},fg=${DARK_FG},bold] #(whoami) "

set -g status-left "\
#[fg=${SESSION_BG}]${HALF_ROUND_OPEN}\
${tm_session_name}\
#[bg=${ACTIVE_WINDOW_BG},fg=${SESSION_BG}]\
${TRIANGLE_CLOSE}\
#[fg=color3,bold]
${tm_zoom_status}\
#[fg=${ACTIVE_WINDOW_BG},bg=default]\
${TRIANGLE_CLOSE} \
"

set -g status-right "\
${tm_playing} \
${tm_date}\
${tm_host}\
#[bg=default,fg=${HOST_BG}]${HALF_ROUND_CLOSE}\
"
