// Opens a terminal started by `mux-popup` as a centered, sized popup, like
// `tmux popup -E`. mux-popup starts the command with `hc run` and labels it
// mux.popup=pending plus its size (mux.popup.width / mux.popup.height: "50%"
// of the window, or "100" cells), then runs `mod.open:popup`. This 1x1 overlay
// finds that terminal, shows it in a dialog (which takes the keyboard), marks it
// mux.popup=shown and closes itself. The dialog closes when the command ends.
// When the app hasn't seen the terminal yet, nothing happens and mux-popup
// opens this mod again.

import { View, div } from "gpui-kit";
import { closeOverlay, hc, openOverlay, props, settings, terminals } from "herdr";

// Monospace cell size estimate, measured with JetBrains Mono: 0.61em advance,
// 1.62em lines.
function cell() {
  const s = settings() ?? {};
  const px = (s.font_size ?? 13) * (s.zoom ?? 1);
  const [padX, padY] = s.terminal_padding ?? [10, 6];
  return { w: px * 0.61, h: px * 1.62, padX, padY };
}

// "50%" -> 0.5 of the window; "100" -> px for 100 cells.
function size(value, cellPx, pad, fallback) {
  const s = String(value ?? "");
  if (s.endsWith("%")) {
    const f = Number(s.slice(0, -1)) / 100;
    return f > 0 ? Math.min(f, 1) : fallback;
  }
  const n = Number(s);
  return n > 0 ? Math.round(n * cellPx + 2 * pad) : fallback;
}

export default class Popup extends View {
  init(_props, _cx) {
    const self = props()?.overlay;
    if (!self) return; // `herdr-app check` renders without an overlay: do nothing
    closeOverlay(self);

    const t = terminals().find((x) => x.state === "live" && x.labels?.["mux.popup"] === "pending");
    if (!t) return;
    hc(["label", t.address, "mux.popup=shown"]);
    const c = cell();
    openOverlay({
      kind: "dialog",
      width: size(t.labels["mux.popup.width"], c.w, c.padX, 0.5),
      height: size(t.labels["mux.popup.height"], c.h, c.padY, 0.5),
      layout: { type: "block", content: { terminal: t.address } },
    });
  }

  render() {
    return div();
  }
}
