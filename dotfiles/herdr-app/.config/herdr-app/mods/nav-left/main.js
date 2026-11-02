// Ctrl+h: focus the pane to the left, like vim-tmux-navigator (mirrors
// ~/.config/rex/plugins/navigate.lua). When nvim, vim or tmux is in the
// foreground the key goes through to it, so it can move within its own splits
// first.
//
// nvim keeps a label on its terminal, mux.nav=nvim:<edges> (the hjkl edges
// its current window touches; see nvim/lua/util/mux_navigation.lua). With it
// this needs no process lookups, and at an edge it moves Herdr's focus itself
// rather than forwarding the key (hc keys costs ~65 ms, pane.go ~20 ms).
// The label also covers nvim opened from lf, which Herdr reports as lf, and
// nvim in a devpod.
//
// keys.json can't pass arguments to mod.open and mods can't import each
// other's files, so nav-left/down/up/right are four copies of this file that
// differ only in DIRECTION and KEY. Each opens as an invisible 1x1 window
// (it doesn't take the keyboard), acts, then closes itself.

import { View, div } from "gpui-kit";
import { closeOverlay, focused, hc, props, run, terminals } from "herdr";

const DIRECTION = "left";
const KEY = "ctrl+h";
const EDGE = "h";
const APPS = ["nvim", "vim", "tmux"];
// A label left on a shell is stale (nvim was killed before removing it)
const SHELLS = ["zsh", "bash", "fish", "sh", "dash", "ksh"];

function basename(path) {
  return String(path ?? "").split("/").pop();
}

// "send" the key to the focused terminal's program, or "move" Herdr's focus.
function decide(address) {
  const t = terminals().find((x) => x.address === address);
  const fg = t?.foreground;
  if (!fg) return "move";
  const label = t.labels?.["mux.nav"];
  if (label?.startsWith("nvim:") && !SHELLS.includes(fg.name)) {
    return label.slice("nvim:".length).includes(EDGE) ? "move" : "send";
  }
  return APPS.includes(fg.name) || APPS.includes(basename(fg.argv?.[0])) ? "send" : "move";
}

export default class Navigate extends View {
  init() {
    const overlay = props()?.overlay;
    if (!overlay) return; // `herdr-app check` renders without an overlay: do nothing
    const address = focused()?.terminal;
    if (address && decide(address) === "send") {
      // Close afterwards: a closed mod's pending work is dropped
      hc(["keys", address, KEY]).finally(() => closeOverlay(overlay));
    } else {
      run("pane.go", { direction: DIRECTION });
      closeOverlay(overlay);
    }
  }

  render() {
    return div();
  }
}
