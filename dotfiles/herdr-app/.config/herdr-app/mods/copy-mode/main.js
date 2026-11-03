// Copy mode, like tmux's `ctrl-b [`: the focused terminal's history opens in
// Neovim (read-only) in a dialog over the window. Move, search and select with
// vim keys; `y` in visual mode copies to the clipboard and leaves, `q` leaves.
// Bind it in keys.json: "ctrl-b [": "mod.open:copy-mode".
//
// It opens as a 1x1 overlay, starts a hidden hc terminal that pipes
// `hc read <terminal> --lines N` into nvim, waits for the app to see that
// terminal, shows it in a dialog and closes itself. The dialog closes when nvim
// exits (the terminal is --rm). It's a snapshot: the terminal keeps running
// underneath. Remote terminals (`machine/t7`) work: hc reads them from here.

import { View, div } from "gpui-kit";
import { closeOverlay, focused, hc, notify, openOverlay, props, terminals } from "herdr";

const LINES = 10000;

// $1: the terminal to read. Trailing blank lines (an empty screen below the
// prompt) are dropped so G lands on the last output.
const SCRIPT = `
hc read "$1" --lines ${LINES} \\
  | awk '{ l[NR] = $0 } NF { n = NR } END { for (i = 1; i <= n; i++) print l[i] }' \\
  | nvim -R -n \\
      -c 'setlocal buftype=nofile bufhidden=wipe noswapfile nomodified' \\
      -c 'nnoremap <buffer> q <Cmd>qa!<CR>' \\
      -c 'xnoremap <buffer> y "+y<Cmd>qa!<CR>' \\
      -c 'normal! G' -
`;

export default class CopyMode extends View {
  init(_props, cx) {
    const self = props()?.overlay;
    if (!self) return; // `herdr-app check` renders without an overlay: do nothing

    const target = focused()?.terminal;
    if (!target) {
      closeOverlay(self);
      notify({ title: "Copy mode", body: "No terminal is focused.", level: "warning", timeout: 3000 });
      return;
    }

    cx.spawn(async (cx) => {
      let address = null;
      try {
        // --no-parent: not a sub-agent of the terminal being read
        const r = await hc(["run", "--bg", "--no-parent", "--rm", "--json", "--name", "copy-mode", "--", "sh", "-c", SCRIPT, "sh", target]);
        address = JSON.parse(r.stdout).address ?? null;
      } catch {}
      if (!address) {
        closeOverlay(self);
        notify({ title: "Copy mode", body: "Couldn't start nvim.", level: "error", timeout: 4000 });
        return;
      }

      // The app learns about new terminals a moment later
      let tries = 0;
      cx.timer.every(50, (cx) => {
        if (terminals().some((t) => t.address === address)) {
          openOverlay({
            kind: "dialog",
            modal: true,
            width: 0.9,
            height: 0.9,
            layout: { type: "block", content: { terminal: address } },
          });
          closeOverlay(self);
        } else if (++tries > 60) {
          closeOverlay(self);
          hc(["kill", address]).catch(() => {});
          notify({ title: "Copy mode", body: "Herdr didn't show the copy-mode terminal.", level: "error", timeout: 4000 });
        }
      });
    });
  }

  render() {
    return div();
  }
}
