// Ctrl+k: focus the pane to the up, like vim-tmux-navigator (mirrors
// ~/.config/rex/plugins/navigate.lua). When nvim, vim or tmux is in the
// foreground the key goes through to it, so it can move within its own splits
// first (nvim runs `herdr-app do pane.go` at its edge, tmux uses
// vim-tmux-navigator).
//
// keys.json can't pass arguments to mod.open and mods can't import each
// other's files, so nav-left/down/up/right are four copies of this file that
// differ only in DIRECTION and KEY. Each opens as an invisible 1x1 window
// (it doesn't take the keyboard), acts, then closes itself. Closing comes last:
// a closed mod's pending work is dropped.

import { View, div } from "gpui-kit";
import { closeOverlay, exec, focused, hc, props, run, terminals } from "herdr";

const DIRECTION = "up";
const KEY = "ctrl+k";
const APPS = ["nvim", "vim", "tmux"];

function basename(path) {
  return String(path ?? "").split("/").pop();
}

// Herdr reports the leader of the terminal's foreground process group. A
// program started from another one (nvim opened from lf) joins that group
// without leading it, so ask ps what else is in the group, on the terminal's
// machine ("sh-backend/t9" runs on sh-backend).
async function foregroundGroupRuns(address, pid) {
  const slash = address.indexOf("/");
  const options = slash > 0 ? { on: address.slice(0, slash) } : {};
  const r = await exec("ps", ["-A", "-o", "pid=,pgid=,tpgid=,comm="], options);
  const rows = r.stdout
    .split("\n")
    .map((line) => line.trim().split(/\s+/))
    .filter((cols) => cols.length >= 4)
    .map(([p, pgid, tpgid, ...comm]) => ({ pid: p, pgid, tpgid, comm: basename(comm.join(" ")) }));
  const group = rows.find((row) => row.pid === String(pid))?.tpgid;
  return Boolean(group) && rows.some((row) => row.pgid === group && APPS.includes(row.comm));
}

// Whether the key should go to the focused terminal's program.
async function passthrough(address) {
  const fg = terminals().find((t) => t.address === address)?.foreground;
  if (!fg) return false;
  if (APPS.includes(fg.name) || APPS.includes(basename(fg.argv?.[0]))) return true;
  try {
    return await foregroundGroupRuns(address, fg.pid);
  } catch {
    return false;
  }
}

export default class Navigate extends View {
  init() {
    const overlay = props()?.overlay;
    if (!overlay) return; // `herdr-app check` renders without an overlay: do nothing
    const address = focused()?.terminal;
    (address ? passthrough(address) : Promise.resolve(false))
      .then((yes) => {
        if (yes) hc(["keys", address, KEY]);
        else run("pane.go", { direction: DIRECTION });
      })
      .finally(() => closeOverlay(overlay));
  }

  render() {
    return div();
  }
}
