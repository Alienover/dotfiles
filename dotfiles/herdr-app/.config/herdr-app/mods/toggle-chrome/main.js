// Hides or shows the sidebar, the tab bar and the bottom status bar together, in one key.
// Bind it in keys.json: "cmd-s": "mod.open:toggle-chrome".
// It opens as a 1x1 overlay, flips both blocks and closes itself at once.
// All follow the sidebar's state, so they never end up out of sync.

import { View, div } from "gpui-kit";
import { run, props, closeOverlay, layout } from "herdr";

const IDS = ["sidebar", "status"];

function findNode(node, id) {
  if (!node || typeof node !== "object") return null;
  if (node.id === id) return node;
  for (const child of node.children ?? []) {
    const hit = findNode(child, id);
    if (hit) return hit;
  }
  return null;
}

export default class ToggleChrome extends View {
  init(_props, _cx) {
    const sidebar = findNode(layout(), "sidebar");
    const action = sidebar?.hidden ? "layout.show" : "layout.hide";
    const overlay = props()?.overlay;
    if (!overlay) return; // `herdr-app check` renders without an overlay: do nothing
    closeOverlay(overlay);
    for (const id of IDS) {
      if (findNode(layout(), id)) run(action, { id });
    }
  }

  render() {
    return div();
  }
}
