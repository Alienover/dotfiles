#!/usr/bin/env bash
# Set up the nav mod (see RECIPE.md): link the dotfiles, give Herdr a layout of
# your own with nav in it, and check that nav receives commands. Safe to re-run.
#
# Usage: setup.sh [source-layout]
#   source-layout: the layout to copy into main-nav when it doesn't exist yet
#   (default: main, Herdr's own). Herdr must be running.

set -euo pipefail

SOURCE=${1:-main}
TARGET=main-nav
HOME_DIR=${HERDR_APP_HOME:-$HOME/.config/herdr-app}
LAYOUT=$HOME_DIR/layouts/$TARGET.json
BLOCK='{"id":"nav","type":"block","size":{"px":0},"content":{"mod":"nav"}}'
# This file is <repo>/dotfiles/herdr-app/.config/herdr-app/mods/nav/setup.sh
REPO=$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../../../../../.." && pwd)

step() { printf '\n==> %s\n' "$*"; }
fail() { printf 'setup.sh: %s\n' "$*" >&2; exit 1; }

step "Linking dotfiles (herdr-app, nvim)"
(cd "$REPO" && ./setup herdr-app nvim)

herdr-app status > /dev/null 2>&1 || fail "Herdr isn't running: open it, then run this again"

step "Layout $TARGET"
if [ -f "$LAYOUT" ]; then
  echo "exists"
else
  herdr-app do layout.clone "{\"name\":\"$SOURCE\",\"as\":\"$TARGET\"}" > /dev/null
  for _ in $(seq 1 40); do [ -f "$LAYOUT" ] && break; sleep 0.1; done
  [ -f "$LAYOUT" ] || fail "layout.clone didn't create $LAYOUT"
  echo "cloned from $SOURCE"
fi

step "nav block in $TARGET"
if jq -e '[.. | objects | select(.content?.mod? == "nav")] | length > 0' "$LAYOUT" > /dev/null; then
  echo "already there"
else
  # The end of the work column; written in place (cat, not mv) in case it's a link
  jq --argjson block "$BLOCK" '(.. | objects | select(.id? == "work") | .children) += [$block]' \
    "$LAYOUT" > "$LAYOUT.tmp"
  jq -e '[.. | objects | select(.content?.mod? == "nav")] | length > 0' "$LAYOUT.tmp" > /dev/null \
    || { rm -f "$LAYOUT.tmp"; fail "no \"work\" column in $LAYOUT: add $BLOCK to any column by hand"; }
  cat "$LAYOUT.tmp" > "$LAYOUT" && rm -f "$LAYOUT.tmp"
  echo "added"
fi

herdr-app do layout.switch --name "$TARGET" > /dev/null
sleep 1.5

step "Checking"
status=$(herdr-app status)
[ "$(jq -r .layout <<< "$status")" = "$TARGET" ] || fail "the shown layout isn't $TARGET"
errors=$(jq -r '.errors[]?' <<< "$status")
[ -z "$errors" ] || fail "Herdr reports: $errors"
herdr-app check "$HOME_DIR/mods/nav" > /dev/null || fail "herdr-app check mods/nav failed"
before=$(jq -r '."nav.pong" // 0' "$HOME_DIR/shared.json")
herdr-app do nav.ping > /dev/null
for _ in $(seq 1 20); do
  after=$(jq -r '."nav.pong" // 0' "$HOME_DIR/shared.json")
  [ "$after" != "$before" ] && break
  sleep 0.1
done
[ "$after" != "$before" ] || fail "nav didn't answer nav.ping"
echo "layout $TARGET, no errors, mod check passed, nav answers"

printf '\nDone. Restart any Neovim that was already running.\n'
