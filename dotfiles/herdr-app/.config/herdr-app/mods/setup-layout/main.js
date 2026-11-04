// Set up my layout: `herdr-app do mod.open:setup-layout` (see mods/nav/RECIPE.md).
//
// Herdr's own layouts can't be edited (the next start moves an edit aside to
// <name>-edited), so this keeps a copy of Herdr's main as layouts/main-layout.json
// and applies PATCHES to it: each one is a change on top of main (the nav
// block, unframed lone panes, ...). A patch that's already there is left
// alone, so it's safe to run again, and an existing main-layout is never replaced,
// only patched. Then it checks the mods the patches need and switches to it.
//
// To add a setting: add an entry to PATCHES.
//
// It copies the file instead of running layout.clone: run() doesn't say when
// the clone is done, and layout.clone switches layouts, which closes this
// overlay before it could patch the copy. So main's clicks aren't copied; on a
// fresh install they're Herdr's defaults anyway.
//
// It opens as a 1x1 overlay, reports with toasts and closes itself. The switch
// comes last because it closes overlays.

import { View, div } from "gpui-kit";
import { appHome, closeOverlay, exec, layouts, notify, props, readTextFile, run, setShared, shared, writeTextFile } from "herdr";

const SOURCE = "main";
const TARGET = "main-layout";
const TITLE = "Set up layout";

// Every node in the tree, floating blocks included.
function* nodes(node) {
  if (!node || typeof node !== "object") return;
  yield node;
  for (const child of [...(node.children ?? []), ...(node.floating ?? [])]) yield* nodes(child);
}

const find = (tree, test) => [...nodes(tree)].filter(test);

// The blocks that show the active tab and frame its panes.
const tabBlocks = (tree) => find(tree, (n) => n.content?.tab !== undefined && n.content.pane);

const NAV_BLOCK = { id: "nav", type: "block", size: { px: 0 }, content: { mod: "nav" } };

// A patch:
//   name     shown in toasts
//   has      (tree) => true when the layout already has it
//   apply    (tree) => changes the tree in place; throws when it can't
//   mods     mods to `herdr-app check` before switching (optional)
//   starting shared key raised when the patch's mod is about to start (newly
//            added, or the layout is about to be shown), cleared on failure
//            (optional; nav uses it to say "Ready")
const PATCHES = [
  {
    // nav only gets its keys where a layout mounts it: a 0 px block at the end
    // of the `work` column.
    name: "nav",
    mods: ["nav"],
    starting: "nav.setup",
    has: (tree) => find(tree, (n) => n.content?.mod === "nav").length > 0,
    apply: (tree) => {
      const work = find(tree, (n) => n.id === "work" && Array.isArray(n.children))[0];
      if (!work) throw new Error(`no "work" column: add ${JSON.stringify(NAV_BLOCK)} to any column by hand`);
      work.children.push(structuredClone(NAV_BLOCK));
    },
  },
  {
    // A tab's only pane gets no frame (border, focus color, header); split
    // panes keep theirs. Unset is false (Herdr's default; layout.clone drops it).
    name: "unframed lone panes",
    has: (tree) => tabBlocks(tree).every((b) => b.content.pane.lone !== true),
    apply: (tree) => {
      for (const b of tabBlocks(tree)) b.content.pane.lone = false;
    },
  },
];

const format = (tree) => JSON.stringify(tree, null, 2) + "\n";

// The shared keys raised by this run, to clear on failure.
let raised = [];

// Returns what it did, or null when there was nothing to do (every patch is in
// and TARGET is shown).
async function setup(cx) {
  const dir = `${appHome()}/layouts`;
  const path = `${dir}/${TARGET}.json`;
  const existing = await readTextFile(path);
  let tree;
  if (existing !== null) {
    tree = JSON.parse(existing);
  } else {
    const source = await readTextFile(`${dir}/${SOURCE}.json`);
    if (source === null) throw new Error(`there's no layouts/${SOURCE}.json`);
    // No cloned_from: Herdr requires its `version` too, which only layout.clone knows
    tree = JSON.parse(source);
    delete tree.cloned_from;
  }

  const shown = existing !== null && shared("layout") === TARGET;
  const missing = PATCHES.filter((p) => !p.has(tree));
  if (shown && missing.length === 0) return null;

  // A mod starts when its block is added or the layout gets shown: raise its
  // key before that, so it sees it
  raised = PATCHES.filter((p) => p.starting && (!shown || missing.includes(p))).map((p) => p.starting);
  for (const key of raised) setShared(key, Date.now());

  for (const p of missing) {
    try {
      p.apply(tree);
    } catch (e) {
      throw new Error(`${p.name}: ${e?.message ?? e}`);
    }
  }

  let did;
  const names = missing.map((p) => p.name).join(", ");
  if (existing === null) {
    await writeTextFile(path, format(tree), null); // fails if it appeared meanwhile
    did = `Made layout ${TARGET}: Herdr's ${SOURCE} with ${names}.`;
  } else if (missing.length > 0) {
    await writeTextFile(path, format(tree), existing); // fails if it changed meanwhile
    did = `Added ${names} to layout ${TARGET}.`;
  } else {
    did = `Layout ${TARGET} is already set up.`;
  }

  for (const mod of new Set(PATCHES.flatMap((p) => p.mods ?? []))) {
    const check = await exec("herdr-app", ["check", `${appHome()}/mods/${mod}`]);
    if (check.code !== 0) {
      throw new Error(`herdr-app check mods/${mod} failed: ${(check.stderr || check.stdout).trim()}`);
    }
  }

  // Herdr picks up a new layout file a moment later
  for (let i = 0; i < 50 && !layouts().includes(TARGET); i++) await cx.sleep(100);
  if (!layouts().includes(TARGET)) throw new Error(`Herdr didn't load layouts/${TARGET}.json`);

  return shown ? `${did}` : `${did} Switching to it.`;
}

export default class SetupLayout extends View {
  init(_props, cx) {
    const overlay = props()?.overlay;
    if (!overlay) return; // `herdr-app check` renders without an overlay: do nothing
    cx.spawn(async (cx) => {
      try {
        const did = await setup(cx);
        if (did === null) {
          notify({ title: TITLE, body: `Already set up: you're on ${TARGET}.`, level: "info", timeout: 5000 });
          closeOverlay(overlay);
          return;
        }
        notify({ title: TITLE, body: did, level: "info", timeout: 5000 });
        closeOverlay(overlay);
        if (shared("layout") !== TARGET) run("layout.switch", { name: TARGET });
      } catch (e) {
        for (const key of raised) setShared(key, null);
        notify({ title: TITLE, body: String(e?.message ?? e), level: "error" });
        closeOverlay(overlay);
      }
    });
  }

  render() {
    return div();
  }
}
