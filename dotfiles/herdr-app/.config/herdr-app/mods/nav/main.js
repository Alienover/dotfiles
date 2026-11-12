// Ctrl+h/j/k/l: focus the neighbouring pane, like vim-tmux-navigator (mirrors
// ~/.config/rex/plugins/navigate.lua). When nvim, vim or tmux is in the
// foreground it moves within its own splits first.
//
// One long-lived copy sits in each layout as a 0 px block, and keys.json sends
// it `nav.left` / `nav.down` / `nav.up` / `nav.right`. (Opening a mod per key
// press was slow and dropped keys: `mod.open` on a mod that is still open
// closes it.) `<mod>.<command>` only reaches shown copies, so the block must
// stay in the layout and not be hidden.
//
// A local nvim is asked over its own RPC socket, which it puts on its terminal
// as the label `nav.nvim` (nvim/lua/util/mux_navigation.lua): it answers
// "moved" or "edge", and on "edge" this moves the Herdr pane. That's
// splits-nav's request/reply (TaterDoge/herdr-mods), over nvim's socket
// instead of a TCP port. Each terminal's requests run in order, one at a time.
// Anything else that wants the key (vim, tmux, an nvim on another machine or
// without the label) gets it typed in with `hc keys`. That's slower: it waits
// until nobody has typed for a moment.
//
// It only gets its keys where a layout mounts it: layouts/main-layout.json has a
// 0 px nav block at the end of the `work` column.

import { View, div } from "gpui-kit";
import { exec, focused, hc, nextCommand, run, setShared, terminals } from "herdr";

const MOVES = {
  left: "h",
  down: "j",
  up: "k",
  right: "l",
};
const APPS = ["nvim", "vim", "tmux"];

function basename(path) {
  return String(path ?? "")
    .split("/")
    .pop();
}

// Whether the focused terminal's program should get the key itself.
function wantsKey(t) {
  const fg = t?.foreground;
  return (
    Boolean(fg) &&
    (APPS.includes(fg.name) || APPS.includes(basename(fg.argv?.[0])))
  );
}

// A local nvim's RPC socket, or null. Remote addresses are `machine/t7`.
function nvimSocket(t) {
  if (t.address.includes("/")) return null;
  const fg = t.foreground;
  const isNvim = fg?.name === "nvim" || basename(fg?.argv?.[0]) === "nvim";
  return isNvim ? (t.labels?.["nav.nvim"] ?? null) : null;
}

// Terminal address -> the last request's promise, so presses stay in order.
const queues = new Map();

async function askNvim(address, socket, direction) {
  const key = MOVES[direction];
  try {
    const r = await exec("nvim", [
      "--server", socket,
      "--remote-expr", `v:lua.require'util.mux_navigation'.herdr('${key}')`,
    ]);
    const answer = r.stdout.trim();
    if (r.code !== 0 || !["moved", "edge", "passthrough"].includes(answer)) {
      // Socket gone or nvim without the new code: type the key in instead
      hc(["keys", address, `ctrl+${key}`]).catch(() => {});
      return;
    }
    // On "edge", only if the person is still there
    if (answer === "edge" && focused()?.terminal === address) {
      run("pane.go", { direction });
    }
  } catch {}
}

function navigate(direction) {
  // `herdr-app do nav.ping` checks that this copy gets commands
  if (direction === "ping") return setShared("nav.pong", Date.now());
  const key = MOVES[direction];
  if (!key) return;
  const address = focused()?.terminal;
  const t = address ? terminals().find((x) => x.address === address) : null;
  if (!t || !wantsKey(t)) return run("pane.go", { direction });

  const socket = nvimSocket(t);
  if (!socket) {
    // Don't wait for hc to finish: every press behind it would wait too
    hc(["keys", address, `ctrl+${key}`]).catch(() => {}); // terminal gone
    return;
  }
  const prev = queues.get(address) ?? Promise.resolve();
  const next = prev.then(() => askNvim(address, socket, direction));
  queues.set(address, next);
  next.then(() => {
    if (queues.get(address) === next) queues.delete(address);
  });
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
