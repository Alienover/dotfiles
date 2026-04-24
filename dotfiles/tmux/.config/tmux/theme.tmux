# Tmux status bar theme.
#
# Layout:
#   left  : [ session-name ] [ zoom-flag ]
#   center: [ window-list (inactive | active) ]
#   right : [ now-playing ] [ date ] [ host ]
#
# `%hidden NAME=...` declares a tmux variable that is NOT exported to the
# environment of child processes (shells, panes, hooks). Without it, every
# theming variable defined here would leak into the user's shell env via
# tmux's normal `setenv -g` semantics for top-level NAME=VALUE lines.
# Requires tmux >= 3.2.

# === Colors ===
%hidden BG="$GUI_BG_BLACK"
%hidden FG="$GUI_PRIMARY"
%hidden DARK="$GUI_BLACK"
%hidden MODE_BG="$GUI_GREEN"
%hidden MATCH_BG="$GUI_SECONDARY"
%hidden MATCH_CUR_BG="$GUI_RED"

# === Glyphs ===
%hidden ZOOM=" 󰲏 "
%hidden SEP="#[fg=${FG},bg=${BG}]▕#[bg=${DARK}]▏#[fg=default]"

# === Status layout ===
set -g status-left-length 32
set -g status-right-length 150
set -g status-interval 5

# === Base styles ===
set -g status-style bg=${BG},fg=${BG}
set -gw window-status-style bg=${BG},fg=${FG}
set -gw window-status-current-style bg=${DARK},fg=${FG}
set -gw window-status-separator ""

# Borders
set -gw popup-border-lines rounded
set -gw popup-border-style fg=${DARK}
set -g pane-border-style fg=${DARK}
set -g pane-active-border-style fg=${DARK}

# Messages / clock / mode
set -g message-style fg=${FG},bg=${BG}
set -gw clock-mode-colour ${FG}
set -gw mode-style fg=${BG},bg=${MODE_BG}

# Copy-mode search highlighting
set -gw copy-mode-match-style bg=${MATCH_BG}
set -gw copy-mode-current-match-style fg=${BG},bg=${MATCH_CUR_BG}

# === Window format ===
set -gw window-status-format "#[fg=${BG}] #[fg=default]  #W  #[fg=${BG}]"
set -gw window-status-current-format "${SEP} #W  #[fg=${DARK}]"

# === Status-left components ===
%hidden SESSION="#[fg=${FG}]#[bg=${FG},fg=${BG},bold] #S #[bg=${DARK},fg=${FG}]"
%hidden ZOOM_FLAG="#[fg=color3,bold]#{?window_zoomed_flag,${ZOOM}, }#[fg=${DARK},bg=default]"

set -g status-left "${SESSION}${ZOOM_FLAG} "

# === Status-right components ===
%hidden PLAYING="#[fg=color3]#(osascript $XDG_CONFIG_HOME/tmux/now-playing.scpt)"
%hidden DATE="#[bg=default,fg=${DARK}]#[bg=${DARK},fg=${FG}] %b %d %R "
%hidden HOST="#[bg=${DARK},fg=${FG}]#[bg=${FG},fg=${BG},bold] #(whoami) #[bg=default,fg=${FG}]"

set -g status-right "${PLAYING} ${DATE}${HOST}"
