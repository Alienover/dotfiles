// Ctrl+h/j/k/l: focus the neighbouring pane, like vim-tmux-navigator (mirrors
// ~/.config/rex/plugins/navigate.lua). When nvim, vim or tmux is in the
// foreground the key goes through to it, so it can move within its own splits
// first.
//
// One long-lived copy sits in each layout as a 0 px block, and keys.json sends
// it `nav.left` / `nav.down` / `nav.up` / `nav.right`. It handles them one at
// a time, in order. (Opening a mod per key press was slow and dropped keys:
// `mod.open` on a mod that is still open closes it.) `<mod>.<command>` only
// reaches shown copies, so the block must stay in the layout and not be hidden.
//
// At its own edge nvim asks Herdr to move (see nvim/lua/util/mux_navigation.lua).

import { View, div } from "gpui-kit";
import { focused, hc, nextCommand, run, setShared, terminals } from "herdr";

const MOVES = {
  left: "ctrl+h",
  down: "ctrl+j",
  up: "ctrl+k",
  right: "ctrl+l",
};
const APPS = ["nvim", "vim", "tmux"];

function basename(path) {
  return String(path ?? "")
    .split("/")
    .pop();
}

// Whether the focused terminal's program should get the key itself.
function wantsKey(address) {
  const fg = terminals().find((x) => x.address === address)?.foreground;
  return (
    Boolean(fg) &&
    (APPS.includes(fg.name) || APPS.includes(basename(fg.argv?.[0])))
  );
}

function navigate(direction) {
  // `herdr-app do nav.ping` checks that this copy gets commands
  if (direction === "ping") return setShared("nav.pong", Date.now());
  const key = MOVES[direction];
  if (!key) return;
  const address = focused()?.terminal;
  if (address && wantsKey(address)) {
    // Don't wait for hc to finish: the mod sometimes only hears back seconds
    // later, and every press behind it would wait too
    hc(["keys", address, key]).catch(() => {}); // terminal gone: nothing to do
  } else {
    run("pane.go", { direction });
  }
}

export default class Nav extends View {
  init(_props, cx) {
    cx.spawn(async () => {
      for (;;) {
        navigate(await nextCommand());
      }
    });
  }

  render() {
    return div();
  }
}
