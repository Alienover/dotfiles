// Ctrl+B prefix, mirroring ~/.config/rex/init.lua: Ctrl+B opens this as an
// invisible 1x1 window (a window doesn't dim the screen like a dialog), it
// takes the keyboard, the next key picks the action, and it closes. It also
// closes when it loses the keyboard (a click elsewhere). When tmux is in the
// foreground Ctrl+B goes straight through, so tmux keeps its own prefix.
//
//   ctrl+b  send ctrl+b to the terminal
//   p       session switcher (mux-switchy in a mux-popup)
//   %  "    split right / down (tmux defaults)
//   c       new tab
//   1-9     go to tab N of this space
//   other   cancel (Esc too)

import { View, div } from "gpui-kit";
import { closeOverlay, exec, focused, hc, home, props, run, terminals } from "herdr";

const BIN = `${home()}/.local/bin`;

function basename(path) {
  return String(path ?? "").split("/").pop();
}

function foregroundIs(address, names) {
  const fg = terminals().find((t) => t.address === address)?.foreground;
  return Boolean(fg) && (names.includes(fg.name) || names.includes(basename(fg.argv?.[0])));
}

function sendCtrlB() {
  const address = focused()?.terminal;
  if (address) hc(["keys", address, "ctrl+b"]);
}

function switchy() {
  exec("env", ["MUX_BACKEND=herdr", `${BIN}/mux-popup`, "-t", "-l", "switchy", "-w", "100", "-h", "25", "mux-switchy &>/dev/null"]);
}

// The action for a key, or null to just close.
function actionFor(e) {
  if (e.keystroke === "ctrl-b") return sendCtrlB;
  if (e.modifiers?.control || e.modifiers?.platform || e.modifiers?.alt) return null;
  const ch = e.key_char ?? e.key;
  if (ch === "p") return switchy;
  if (ch === "%") return () => run("pane.split", { direction: "right" });
  if (ch === '"') return () => run("pane.split", { direction: "down" });
  if (ch === "c") return () => run("tab.new", {});
  if (/^[1-9]$/.test(ch)) return () => run("tab.select", { index: Number(ch) });
  return null;
}

export default class Prefix extends View {
  init(_props, cx) {
    this.overlay = props()?.overlay;
    if (!this.overlay) return; // `herdr-app check` renders without an overlay: do nothing
    const address = focused()?.terminal;
    if (address && foregroundIs(address, ["tmux"])) {
      closeOverlay(this.overlay);
      hc(["keys", address, "ctrl+b"]);
      return;
    }
    this.handle = cx.focus_handle();
    this.handle.focus();
    // A window stays open when focus moves away, so watch for that
    this.watch = cx.timer.every(150, () => {
      if (!this.handle.is_focused()) this.close();
    });
  }

  close() {
    this.watch?.cancel();
    this.watch = null;
    closeOverlay(this.overlay);
  }

  render(_cx) {
    let el = div().id("prefix").size_full();
    if (this.handle) {
      el = el.track_focus(this.handle).on_key_down((e, cx) => {
        // Modifier presses on their own (shift for % and ") don't end the prefix.
        if (["shift", "control", "alt", "platform", "function"].includes(e.key)) return;
        cx.stop_propagation();
        const action = actionFor(e);
        this.close(); // first, so splits and tabs act on the pane behind
        if (action) action();
      });
    }
    return el;
  }
}
