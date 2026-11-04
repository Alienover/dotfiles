// Set up the nav mod: `herdr-app do mod.open:setup-nav` (see mods/nav/RECIPE.md).
//
// nav only gets its keys where a layout mounts it, and Herdr's own layouts
// can't be edited (the next start moves an edit aside to <name>-edited). So
// this writes layouts/main-nav.json: Herdr's main plus a 0 px nav block at the
// end of the `work` column. Then it checks the nav mod and switches to
// main-nav. A main-nav that already exists is never replaced; nav is only added
// to it if missing. Safe to run again.
//
// It copies the file instead of running layout.clone: run() doesn't say when
// the clone is done, and layout.clone switches layouts, which closes this
// overlay before it could add the block. So main's clicks aren't copied; on a
// fresh install they're Herdr's defaults anyway.
//
// It opens as a 1x1 overlay, reports with toasts and closes itself. The switch
// comes last because it closes overlays. nav then says "ready" the first time
// it starts after this (the shared key nav.setup, cleared again on failure).

import { View, div } from "gpui-kit";
import { appHome, closeOverlay, exec, layouts, notify, props, readTextFile, run, setShared, shared, writeTextFile } from "herdr";

const SOURCE = "main";
const TARGET = "main-nav";
const BLOCK = { id: "nav", type: "block", size: { px: 0 }, content: { mod: "nav" } };
const TITLE = "Set up Nav";

function hasNav(node) {
  if (!node || typeof node !== "object") return false;
  if (Array.isArray(node)) return node.some(hasNav);
  return node.content?.mod === "nav" || hasNav(node.children) || hasNav(node.floating);
}

// Add BLOCK as the last child of the `work` column; false when there's none.
function addToWork(node) {
  if (!node || typeof node !== "object") return false;
  if (node.id === "work" && Array.isArray(node.children)) {
    node.children.push(BLOCK);
    return true;
  }
  return (node.children ?? []).some(addToWork);
}

const format = (tree) => JSON.stringify(tree, null, 2) + "\n";

function withNav(text, path) {
  const tree = JSON.parse(text);
  if (!addToWork(tree)) {
    throw new Error(`${path} has no "work" column: add ${JSON.stringify(BLOCK)} to any column by hand`);
  }
  return tree;
}

// Returns what it did, or null when there was nothing to do (TARGET has nav
// and is already shown). Otherwise a nav copy is about to start, in a written
// or a newly shown layout: the flag goes up before that, so nav sees it.
async function setup(cx) {
  const dir = `${appHome()}/layouts`;
  const path = `${dir}/${TARGET}.json`;
  const existing = await readTextFile(path);
  const ready = existing !== null && hasNav(JSON.parse(existing));
  if (ready && shared("layout") === TARGET) return null;
  setShared("nav.setup", Date.now());
  let did;
  if (existing === null) {
    const source = await readTextFile(`${dir}/${SOURCE}.json`);
    if (source === null) throw new Error(`there's no layouts/${SOURCE}.json`);
    // No cloned_from: Herdr requires its `version` too, which only layout.clone knows
    const tree = withNav(source, `layouts/${SOURCE}.json`);
    await writeTextFile(path, format(tree), null); // fails if it appeared meanwhile
    did = `Made layout ${TARGET} (Herdr's ${SOURCE} with nav in it).`;
  } else if (!ready) {
    await writeTextFile(path, format(withNav(existing, `layouts/${TARGET}.json`)), existing);
    did = `Added nav to layout ${TARGET}.`;
  } else {
    did = `Layout ${TARGET} already has nav.`;
  }

  const check = await exec("herdr-app", ["check", `${appHome()}/mods/nav`]);
  if (check.code !== 0) {
    throw new Error(`herdr-app check mods/nav failed: ${(check.stderr || check.stdout).trim()}`);
  }

  // Herdr picks up a new layout file a moment later
  for (let i = 0; i < 50 && !layouts().includes(TARGET); i++) await cx.sleep(100);
  if (!layouts().includes(TARGET)) throw new Error(`Herdr didn't load layouts/${TARGET}.json`);

  return did;
}

export default class SetupNav extends View {
  init(_props, cx) {
    const overlay = props()?.overlay;
    if (!overlay) return; // `herdr-app check` renders without an overlay: do nothing
    cx.spawn(async (cx) => {
      try {
        const did = await setup(cx);
        if (did === null) {
          notify({ title: TITLE, body: `Already set up: you're on ${TARGET}, which has nav.`, level: "info", timeout: 5000 });
          closeOverlay(overlay);
          return;
        }
        notify({ title: TITLE, body: `${did} Switching to it.`, level: "info", timeout: 5000 });
        closeOverlay(overlay);
        run("layout.switch", { name: TARGET });
      } catch (e) {
        setShared("nav.setup", null);
        notify({ title: TITLE, body: String(e?.message ?? e), level: "error" });
        closeOverlay(overlay);
      }
    });
  }

  render() {
    return div();
  }
}
