# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "~/Documents/dev/spendhound"

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "🔖 SpendHound"; then

  # Create a new window inline within session layout definition.
  new_window "console"
  split_v
  select_pane 1
  resize_pane_h 30
  split_h
  select_pane 3

  new_window "editor"
  run_cmd "vim"

  # Select the default active window on session creation.
  select_window 1
fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
