# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "$HOME/Documents/repos/github.com/Yipit/spendhound"

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "🔖 SpendHound"; then

  # Create a new window inline within session layout definition.
  new_window
  split_vl 30
  split_h

  new_window
  run_cmd "vim"

  # Select the default active window on session creation.
  select_window 1
fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
