# ~/.profile: read by login shells only (ssh logins, `bash -l`).
# bash skips this file if ~/.bash_profile or ~/.bash_login exists.
#
# Everything a shell needs (environment, mise, aliases, prompt) lives in
# ~/.bashrc so non-login shells (Herdr panes, tmux windows) get it too.
# Only put things here that should run once per login session.

if [ -n "$BASH_VERSION" ]; then
  [ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"
else
  # Non-bash login shell (sh/dash): load at least the shared environment.
  [ -f "$HOME/.config/shell/profile.default" ] && . "$HOME/.config/shell/profile.default"
fi

# ---- login-only setup below ----
# the default umask is set in /etc/profile
#umask 022
