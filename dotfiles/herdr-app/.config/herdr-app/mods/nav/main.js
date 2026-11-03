// Ctrl+h/j/k/l: focus the neighbouring pane, like vim-tmux-navigator (mirrors
// ~/.config/rex/plugins/navigate.lua). When nvim, vim or tmux is in the
// foreground the key goes through to it, so it can move within its own splits
// first. A zoomed pane is never left (tmux-navigator's disable_when_zoomed),
// and at the window's edge nothing happens.
//
// One long-lived copy sits in each layout as a 0 px block, and keys.json sends
// it `nav.left` / `nav.down` / `nav.up` / `nav.right`. It handles them one at
// a time, in order. (Opening a mod per key press was slow and dropped keys:
// `mod.open` on a mod that is still open closes it.) `<mod>.<command>` only
// reaches shown copies, so the block must stay in the layout and not be hidden.
//
// nvim answers each key with a label on its own terminal,
// `nav.reply=<id>:<moved|edge>:<direction>` (nvim/lua/util/mux_navigation.lua),
// and on `edge` this moves the Herdr pane. The request/reply shape is
// splits-nav's (TaterDoge/herdr-mods); a label instead of its local TCP port
// reaches nvim on other machines too. While keys are going to nvim, one task
// per terminal watches for its replies; it stops REPLY_MS after the last key
// was delivered. `hc keys` returns once the key is in: ~100 ms normally, but
// ~2 s right after the terminal resized (a zoom), so the window starts then,
// not at the press (at most WATCH_MAX_MS in all).
// A reply for a terminal that's no longer focused, or now zoomed, is dropped.
// A label holds one value: two replies within one poll count as the last one.

import { View, div } from "gpui-kit";
import { focused, hc, nextCommand, panes, run, setShared, terminals } from "herdr";

const MOVES = {
  left: "ctrl+h",
  down: "ctrl+j",
  up: "ctrl+k",
  right: "ctrl+l",
};
const APPS = ["nvim", "vim", "tmux"];
const REPLY_MS = 1000;
const WATCH_MAX_MS = 10000;
const POLL_MS = 20;

function basename(path) {
  return String(path ?? "")
    .split("/")
    .pop();
}

function terminal(address) {
  return terminals().find((x) => x.address === address);
}

// Whether the focused terminal's program should get the key itself.
function wantsKey(address, pane) {
  if (pane?.program?.key === "nvim") return true;
  const fg = terminal(address)?.foreground;
  return (
    Boolean(fg) &&
    (APPS.includes(fg.name) || APPS.includes(basename(fg.argv?.[0])))
  );
}

function reply(address) {
  return terminal(address)?.labels?.["nav.reply"] ?? null;
}

function focusedPane() {
  const id = focused()?.pane;
  return id ? panes().find((p) => p.pane === id) : null;
}

// Terminal address -> { until, sending, last, stop }: the reply watchers
// running now. `sending` counts keys not yet delivered.
const watchers = new Map();

// Send `key` to nvim and watch `address` for its replies, until REPLY_MS after
// the last key was delivered. The watcher starts before the key goes out, so
// `last` is the reply from before this press.
function sendAndWatch(address, key, cx) {
  let state = watchers.get(address);
  if (!state) {
    const now = Date.now();
    state = { until: now + REPLY_MS, sending: 0, last: reply(address), stop: now + WATCH_MAX_MS };
    watchers.set(address, state);
    spawnWatcher(address, state, cx);
  }
  state.sending++;
  state.stop = Math.max(state.stop, Date.now() + WATCH_MAX_MS);
  // Don't wait for hc to finish: every press behind it would wait too
  hc(["keys", address, key])
    .catch(() => {}) // terminal gone: nothing to do
    .finally(() => {
      state.sending--;
      state.until = Date.now() + REPLY_MS;
    });
}

function spawnWatcher(address, state, cx) {
  cx.spawn(async (cx) => {
    try {
      while ((state.sending > 0 || Date.now() < state.until) && Date.now() < state.stop) {
        await cx.sleep(POLL_MS);
        const now = reply(address);
        if (now === null || now === state.last) continue;
        state.last = now;
        const [, result, direction] = now.split(":");
        if (result !== "edge" || !MOVES[direction]) continue;
        // The person moved on, or zoomed in, before nvim answered
        if (focused()?.terminal !== address || focusedPane()?.zoomed) continue;
        run("pane.go", { direction });
      }
    } finally {
      watchers.delete(address);
    }
  });
}

function navigate(direction, cx) {
  // `herdr-app do nav.ping` checks that this copy gets commands
  if (direction === "ping") return setShared("nav.pong", Date.now());
  const key = MOVES[direction];
  if (!key) return;
  const address = focused()?.terminal;
  const pane = focusedPane();
  if (address && wantsKey(address, pane)) {
    sendAndWatch(address, key, cx);
  } else if (!pane?.zoomed) {
    run("pane.go", { direction });
  }
}

export default class Nav extends View {
  init(_props, cx) {
    cx.spawn(async (cx) => {
      for (;;) {
        navigate(await nextCommand(), cx);
      }
    });
  }

  render() {
    return div();
  }
}
