# Go back to the last client
bind a switch-client -l

# vim-like copy-paste keymappings
bind -T copy-mode-vi 'v' send -X begin-selection

# tmux pupup required
bind p run "tmux-popup -w 100 -h 25 -s popup -B tmux-switchy"

# tmux floating terminal
bind T run "tmux-popup -t -d #{pane_current_path} tmux-floatx"

bind F run "tmux-lf"

# reload config file
bind r source-file $XDG_CONFIG_HOME/tmux/tmux.conf \; display "Config Reloaded!"
