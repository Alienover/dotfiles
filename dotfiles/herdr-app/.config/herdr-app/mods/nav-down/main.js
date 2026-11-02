// Ctrl+j: focus the pane to the down, like vim-tmux-navigator (mirrors
// ~/.config/rex/plugins/navigate.lua). When nvim, vim or tmux is in the
// foreground the key goes through to it, so it can move within its own splits
// first (nvim runs `herdr-app do pane.go` at its edge, tmux uses
// vim-tmux-navigator).
//
// keys.json can't pass arguments to mod.open and mods can't import each
// other's files, so nav-left/down/up/right are four copies of this file that
// differ only in DIRECTION and KEY. Each opens as a 1x1 overlay, acts, and
// closes itself.

import { View, div } from "gpui-kit";
import { closeOverlay, focused, hc, props, run, terminals } from "herdr";

const DIRECTION = "down";
const KEY = "ctrl+j";
const APPS = ["nvim", "vim", "tmux"];

function basename(path) {
  return String(path ?? "").split("/").pop();
}

// The focused terminal's address when one of APPS runs in its foreground.
function passthroughTerminal() {
  const address = focused()?.terminal;
  if (!address) return null;
  const fg = terminals().find((t) => t.address === address)?.foreground;
  if (!fg) return null;
  return APPS.includes(fg.name) || APPS.includes(basename(fg.argv?.[0])) ? address : null;
}

export default class Navigate extends View {
  init() {
    const overlay = props()?.overlay;
    if (!overlay) return; // `herdr-app check` renders without an overlay: do nothing
    closeOverlay(overlay);
    const address = passthroughTerminal();
    if (address) hc(["keys", address, KEY]);
    else run("pane.go", { direction: DIRECTION });
  }

  render() {
    return div();
  }
}
