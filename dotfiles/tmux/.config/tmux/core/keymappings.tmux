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
bind y setw synchronize-panes

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
bind p run "tmux-popup -w 80 -h 20 -s popup \"zsh $__TM_TMUX_HOME/switchy.sh\""

# tmux floating terminal
unbind T
bind T run "tmux-popup \"source $__TM_TMUX_HOME/floatterm.sh\" -s popup -t"

unbind F
bind F run "tmux-yazi"

is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"

# smart pane switching with awareness of vim splits
bind h if-shell "$is_vim" "send-keys C-w\ h" "select-pane -L"
bind j if-shell "$is_vim" "send-keys C-w\ j" "select-pane -D"
bind k if-shell "$is_vim" "send-keys C-w\ k" "select-pane -U"
bind l if-shell "$is_vim" "send-keys C-w\ l" "select-pane -R"

# reload config file
bind r source-file $HOME/.tmux.conf \; display "Config Reloaded!"

