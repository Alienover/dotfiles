# ~/.bashrc: read by every interactive non-login bash, and by login shells
# through ~/.profile. Each step runs as few times as possible:
#   1. Environment: exported vars, loaded once per session. Child shells
#      (tmux panes, nested bash) inherit them and skip this part. Runs in
#      non-interactive shells too (ssh/scp commands, `bash -l -c` from
#      nvim-remote), whose stdout is data, so it must print nothing.
#   2. Interactive: things a child can't inherit (aliases, functions, hooks,
#      prompt), loaded once per shell. Re-sourcing this file is a no-op;
#      use `exec bash` to reload, or `unset __DEVPOD_ENV_LOADED` first to
#      reload the environment as well.

SHELL_CONFIG="$HOME/.config/shell"

# ---------------------------------------------------------------------------
# 1. Environment (once per session)
# ---------------------------------------------------------------------------
if [ -z "${__DEVPOD_ENV_LOADED-}" ]; then
  __env_loaded_here=1

  # Shared profile: XDG dirs, TERM, GPG_TTY, EDITOR, LANG, ~/.local/bin on PATH
  [ -f "$SHELL_CONFIG/profile.default" ] && . "$SHELL_CONFIG/profile.default"
  # Customized color scheme (exported vars other tools read)
  [ -f "$SHELL_CONFIG/colors.sh" ] && . "$SHELL_CONFIG/colors.sh"

  [ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"

  # mise: puts tool versions (nvim, node, fzf, ...) on PATH.
  command -v mise >/dev/null 2>&1 && eval "$(mise activate bash)"

  # Drop duplicate PATH entries (e.g. one inherited from the parent process).
  __path_dedupe() {
    local p out= IFS=:
    local -a parts
    read -ra parts <<<"$PATH"
    for p in "${parts[@]}"; do
      case ":$out:" in *":$p:"*) ;; *) out="${out:+$out:}$p" ;; esac
    done
    export PATH="$out"
  }
  __path_dedupe
  unset -f __path_dedupe

  export __DEVPOD_ENV_LOADED=1
fi

case $- in
  *i*) ;;
  *) unset __env_loaded_here; return ;;
esac

# ---------------------------------------------------------------------------
# 2. Interactive only (once per shell)
# ---------------------------------------------------------------------------
[ -n "${__BASHRC_LOADED-}" ] && return
__BASHRC_LOADED=1

# Per-terminal values a nested shell can't inherit. The first shell already
# got them from profile.default above.
if [ -z "${__env_loaded_here-}" ]; then
  export GPG_TTY=$(tty)
  [ -n "$TMUX" ] && export TERM=tmux-256color
fi
unset __env_loaded_here

# mise's prompt hook is a shell function, not inherited by child shells.
if ! declare -F _mise_hook >/dev/null && command -v mise >/dev/null 2>&1; then
  eval "$(mise activate bash)"
fi

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
# append to the history file, don't overwrite it
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and update LINES and COLUMNS.
shopt -s checkwinsize

# Forwarded ssh agent: DevPod creates a new /tmp/auth-agent*/listener.sock per
# ssh connection, so long-lived shells (tmux, Herdr) keep a dead path after a
# reconnect. Switch to the newest live socket whenever the current one is gone.
__fix_ssh_agent() {
  [ -S "$SSH_AUTH_SOCK" ] && return
  local s
  for s in $(ls -t /tmp/auth-agent*/listener.sock 2>/dev/null); do
    [ -S "$s" ] && { export SSH_AUTH_SOCK="$s"; return; }
  done
}
__fix_ssh_agent
PROMPT_COMMAND="__fix_ssh_agent${PROMPT_COMMAND:+;$PROMPT_COMMAND}"

# Aliases go after mise so `command -v nvim`/`bat`/`eza` checks find its tools.
[ -f "$SHELL_CONFIG/alias.sh" ] && . "$SHELL_CONFIG/alias.sh"

# enable programmable completion features (also loads __git_ps1 on Debian).
# Login shells already got it from /etc/profile.d/bash_completion.sh.
if [ -z "${BASH_COMPLETION_VERSINFO-}" ] && ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if ! declare -F __git_ps1 >/dev/null; then
  for f in /usr/lib/git-core/git-sh-prompt /usr/share/git/completion/git-prompt.sh; do
    [ -f "$f" ] && { . "$f"; break; }
  done
  unset f
fi
GIT_PS1_SHOWDIRTYSTATE=1        # + for staged, * if unstaged
GIT_PS1_SHOWSTASHSTATE=1        # $ if something is stashed.
GIT_PS1_SHOWUNTRACKEDFILES=1    # % if there are untracked files
GIT_PS1_SHOWUPSTREAM=1          # <, >, <> behind, ahead, or diverged from upstream.
GIT_PS1_STATESEPARATOR=" "      # separator between branch name and state symbols
GIT_PS1_DESCRIBE_STYLE=1        # show commit relative to tag or branch, when detached HEAD
GIT_PS1_SHOWCOLORHINTS=1

# bash theme - partly inspired by https://github.com/ohmyzsh/ohmyzsh/blob/master/themes/robbyrussell.zsh-theme
__bash_prompt() {
  local workspace="${DEVPOD_WORKSPACE_ID:+\[\033[0;32m\]($DEVPOD_WORKSPACE_ID) }"
  local lightblue='\[\033[1;34m\]'
  local removecolor='\[\033[0m\]'
  local git=''
  declare -F __git_ps1 >/dev/null && git='$(__git_ps1)'
  PS1="${workspace}${lightblue}\w${removecolor}${git}\n\$ "
  unset -f __bash_prompt
}
__bash_prompt
export PROMPT_DIRTRIM=4
