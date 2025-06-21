case "$SYSTEM_OS" in
  "darwin")
    export OBSIDIAN_VAULT="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/Obsidian"
    ;;;
  *)
    # Fallback
    export OBSIDIAN_VAULT="$HOME/Documents/Obsidian"
esac

alias obsidian="cd '$OBSIDIAN_VAULT'"
