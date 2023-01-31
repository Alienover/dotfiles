# unbind default prefix and set it to Ctrl+a
unbind C-b
set -g prefix C-a
bind C-a send-prefix

# for nested tmux sessions
bind-key a send-prefix

# tile all windows
unbind =
bind = select-layout tiled

# reload config file
bind r source-file $HOME/.tmux.conf \; display "Config Reloaded!"

# split window just like vim
unbind v
bind v split-window -h -c "#{pane_current_path}"
unbind s
bind s split-window -v -c "#{pane_current_path}"

# synchronize all panes in a window
bind y setw synchronize-panes

# pane movement shortcuts
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

bind -r C-h select-window -t :-
bind -r C-l select-window -t :+

# Resize pane shortcuts
bind -r H resize-pane -L 10
bind -r J resize-pane -D 10
bind -r K resize-pane -U 10
bind -r L resize-pane -R 10

# Go back to the last client
bind b switch-client -l

# more settings to make copy-mode more vim-like
unbind [
bind Escape copy-mode

# vim-like copy-paste keymappings
bind -Tcopy-mode-vi 'v' send -X begin-selection
bind -Tcopy-mode-vi 'y' send -X copy-pipe-and-cancel "tmux show-buffer | pbcopy"

__TM_TMUX_HOME="$XDG_CONFIG_HOME/tmux"

# tmux pupup required
unbind p
bind p run "tmux-popup -w 70 -h 16 -y 0 -s popup \"sh $__TM_TMUX_HOME/switchy.sh\""

# tmux floating terminal
unbind T
bind T run "tmux-popup \"source $__TM_TMUX_HOME/floatterm.sh\" -s popup -t"
