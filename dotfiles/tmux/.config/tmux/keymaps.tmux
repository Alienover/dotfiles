# unbind default prefix and set it to Ctrl+a
unbind C-b
set -g prefix C-a
bind C-a send-prefix

# for nested tmux sessions
bind-key a send-prefix

# tile all windows
unbind =
bind = select-layout tiled

# split window just like vim
unbind v
bind v split-window -h -c "#{pane_current_path}"
unbind s
bind s split-window -v -c "#{pane_current_path}"

# synchronize all panes in a window
unbind S
bind S setw synchronize-panes

bind -r C-h previous-window
bind -r C-l next-window

# Resize pane shortcuts
bind -r H resize-pane -L 10
bind -r J resize-pane -D 10
bind -r K resize-pane -U 10
bind -r L resize-pane -R 10

# Go back to the last client
bind a switch-client -l

# more settings to make copy-mode more vim-like
unbind [
bind Escape if -F '#{pane_in_mode}' 'send-keys q' 'copy-mode'

# vim-like copy-paste keymappings
bind -T copy-mode-vi 'v' send -X begin-selection

# tmux pupup required
unbind p
bind p run "tmux-popup -w 100 -h 25 -s popup -B tmux-switchy"

# tmux floating terminal
unbind T
bind T run "tmux-popup -t -d #{pane_current_path} tmux-floatx"

unbind F
bind F run "tmux-lf"

# reload config file
bind r source-file $XDG_CONFIG_HOME/tmux/tmux.conf \; display "Config Reloaded!"
