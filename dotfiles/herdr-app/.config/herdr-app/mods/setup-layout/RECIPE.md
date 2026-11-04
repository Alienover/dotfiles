# Setup layout

`herdr-app do mod.open:setup-layout` makes my own copy of Herdr's `main` layout, `main-layout`, with my changes applied,
and switches to it. It draws nothing: it reports with toasts and closes itself.

## Fresh install

With Herdr open:

```sh
cd ~/src/dotfiles && ./setup herdr-app
herdr-app do mod.open:setup-layout
```

1. **It writes `layouts/main-layout.json`:** a copy of Herdr's `main` with each patch in `PATCHES` applied. Herdr's own
   layouts can't be edited: on the next start Herdr moves an edited one aside and restores its own. An existing
   `main-layout` is never replaced; only the patches it's missing are applied.
2. **It checks the mods the patches use** (`herdr-app check`), then **switches to `main-layout`** (unless it's already
   shown).

Running it again is safe. On `main-layout` with every patch, it only says "Already set up: you're on main-layout." On a
failure, the error toast says what to fix.

`main-layout` is a copy of the file, so it starts with Herdr's default look for `main`, not your clicks from another
layout. Herdr never updates it: to pick up a newer `main`, delete `layouts/main-layout.json` and run it again.

## The patches

| Patch | Change | Why |
| --- | --- | --- |
| `nav` | a 0 px `nav` block at the end of the `work` column | `nav` only gets its keys where a layout mounts it (`mods/nav/RECIPE.md`) |
| `unframed lone panes` | `"lone": false` (or unset, the default) in each tab block's `pane` frame | a tab's only pane has no border, focus color or header; split panes keep theirs. Herdr has no option for the border alone |

## Built from

- **`mod.json`:** `{ "place": "none", "overlay": { "kind": "window", "frame": "none", "width": 1, "height": 1 } }`.
- **`main.js`:** one `View` that does the steps in `init` (`cx.spawn`) and renders an empty `div()`. Under
  `herdr-app check` there's no `props().overlay`, so it does nothing.
  - `PATCHES` is a list of `{ name, has(tree), apply(tree), mods?, starting? }`. `has` says the layout already has
    it, `apply` changes the tree in place (throwing when it can't), `mods` are checked before switching, and
    `starting` is a shared key raised just before that patch's mod can start (newly added, or the layout is about to
    be shown) and cleared on failure.
  - It writes the file itself (`readTextFile` / `writeTextFile`, with the text it read as `expected`) rather than
    running `layout.clone`. `run()` doesn't say when a command is done, and `layout.clone` switches layouts, which
    closes the overlay first.
  - It waits for `layouts()` to list `main-layout` before switching; `layout.switch` comes last because it closes
    overlays.

To add a layout setting: add an entry to `PATCHES`.

## Watch out

- **Don't add `cloned_from` to a hand-written layout.** Herdr rejects it without the `version` that only
  `layout.clone` fills in ("missing field `version`"), and then doesn't apply the layout.
- A patch whose `has` is wrong is applied on every run: make `has` true right after `apply`.
- **`layout.clone` (and Herdr's own writes) drop fields set to their default**, like `"lone": false`: a `has` should
  treat an unset field as its default, or it reapplies the patch every run.
- `main.js` links into this repo; Herdr watches the folder, not the link target. Re-create the link
  (`ln -sfn "$(readlink main.js)" main.js`) to reload an edit.

## Done when

- `herdr-app check` passes on `mods/setup-layout`.
- `herdr-app do mod.open:setup-layout` ends on `main-layout` with one `nav` block, no `"lone": true` on the tab block and
  no errors in `herdr-app status`. Run again, it writes nothing and says "Already set up".
