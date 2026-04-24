# mise — Activate the polyglot runtime/tool version manager when installed.

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi
