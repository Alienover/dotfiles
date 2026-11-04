# Nav

`ctrl+h/j/k/l` moves focus to the neighbouring pane, like vim-tmux-navigator. Inside Neovim the keys move between
Neovim's windows first and leave Neovim only at its edge. The mod draws nothing.

## Fresh install

With Herdr open:

```sh
cd ~/src/dotfiles && ./setup herdr-app nvim
herdr-app do mod.open:setup-layout
```

Then restart any Neovim that was already running.

1. **`./setup herdr-app nvim`** links `nav`, `setup-layout`, `keys.json` (which binds the keys) and the Neovim config
   into `~/.config/`.
2. **`mod.open:setup-layout`** runs the `setup-layout` mod (`mods/setup-layout/`), which reports with toasts:
   - **It writes `layouts/main-nav.json`:** a copy of Herdr's `main` with each of the mod's patches applied. Herdr's
     own layouts can't be edited: on the next start Herdr moves an edited one aside and restores its own. An existing
     `main-nav` is never replaced; only the patches it's missing are applied. The patches:
     - **nav:** `nav` as a 0 px block at the end of the `work` column,
       `{"id":"nav","type":"block","size":{"px":0},"content":{"mod":"nav"}}`. `nav` has to be in the layout on screen.
     - **unframed lone panes:** `"lone": false` in each tab block's `pane` frame, so a tab's only pane has no border,
       focus color or header; split panes keep theirs.
   - **It checks the mods the patches use** (`herdr-app check mods/nav`), then **switches to `main-nav`.**
   - **`nav` confirms** with "Ready: ctrl+h/j/k/l move between panes" once it runs there.

Running it again is safe. If you're already on a `main-nav` with every patch, it only says "Already set up". On a
failure, the error toast says what to fix. To add another layout setting, add an entry to `PATCHES` in
`mods/setup-layout/main.js` (`name`, `has`, `apply`, optional `mods` and `starting`).

`main-nav` is a copy of the file, so it starts with Herdr's default look for `main`, not your clicks from another
layout. Herdr never updates it: to pick up a newer `main`, delete `layouts/main-nav.json` and run `setup-layout`
again.

## How it behaves

`keys.json` binds `ctrl-h/j/k/l` to `nav.left/down/up/right` in the `terminal` section. On each press:

| Focused terminal | What happens |
| --- | --- |
| Shell, or any other program | `pane.go` |
| Local Neovim | Neovim is asked over its RPC socket and answers `moved` (it changed window: done), `edge` (no window that way: `pane.go`), or `passthrough` (insert, command-line or terminal mode: the key keeps its meaning, e.g. `ctrl+h` deletes a character) |
| vim, tmux, Neovim on another machine | the key is typed in with `hc keys`, and the program handles it |

There's no wrap-around at the window's edge. Presses to one Neovim run in order. A local Neovim answers in about 50 ms.

## Built from

- **`mod.json`:** `{ "place": "none" }`.
- **`main.js`:** one `View` that renders an empty `div()` and loops over `nextCommand()` (`left`, `down`, `up`,
  `right`, `ping`).
  - It finds the focused terminal with `focused()` and `terminals()`.
  - It asks Neovim with `exec("nvim", ["--server", socket, "--remote-expr", "v:lua.require'util.mux_navigation'.herdr('h')"])`.
  - It moves with `run("pane.go", { direction })`, falling back to `hc(["keys", terminal, "ctrl+h"])`.
  - `nav.ping` writes `Date.now()` to `shared("nav.pong")`.
  - On start, if `shared("nav.setup")` is set, it posts the "Ready" toast and clears it.
- **`mods/setup-layout/`:** a 1×1 overlay window (`mod.json`) that does the Fresh install steps and closes itself.
  - `PATCHES` lists each change on top of `main`: `has(tree)` says it's there, `apply(tree)` makes it.
  - It writes the layout file itself (`readTextFile` / `writeTextFile`) rather than running `layout.clone`. `run()`
    doesn't say when a command is done, and `layout.clone` switches layouts, which closes the overlay first.
  - A patch's `starting` key (`nav.setup` for nav) is set before writing or switching when its mod is about to start
    (newly added, or the layout is about to be shown), and cleared on failure.
- **Neovim side:** `dotfiles/nvim/.config/nvim/lua/util/mux_navigation.lua`, mapped in
  `lua/plugins/nvim-mux-navigation.lua`.
  - At startup Neovim labels its terminal `nav.nvim=<v:servername>` (`hc label`) and removes the label on exit.
  - `herdr(key)` returns `moved` / `edge` / `passthrough`.
- **Programs it runs:** `nvim` and `hc`. No network, no files.

## Watch out

- **No block in the shown layout, no navigation.** `nav.left` only reaches a copy already running there, and fails
  silently otherwise.
- **Don't type keys into Neovim with `hc keys`.** It holds input until nobody has typed for about 3 s, which made
  navigation lag. That's why Neovim is asked over RPC. vim, tmux and remote Neovim still use it and can lag.
- **Don't open the mod per key press** (`mod.open`): a second open closes it, so quick presses get dropped.
- **Edits here don't hot-reload.** `~/.config/herdr-app/mods/nav/main.js` links into this repo, and Herdr watches the
  folder, not the link target. Re-create the link (`ln -sfn "$(readlink main.js)" main.js` in that folder) or restart
  Herdr.
- **Shells lose these keys:** `ctrl+h` (backspace), `ctrl+l` (clear), `ctrl+k` (kill line), `ctrl+j` (newline).
- A Neovim started before the setup gets `hc keys` until it restarts.
- **Don't add `cloned_from` to a hand-written layout.** Herdr rejects it without the `version` that only
  `layout.clone` fills in ("missing field `version`"), and then doesn't apply the layout.

## Done when

- `herdr-app check` passes on `mods/nav` and `mods/setup-layout`.
- `herdr-app do mod.open:setup-layout` ends on `main-nav` with one `nav` block, `"lone": false` on the tab block, no
  errors in `herdr-app status`, and the "Ready" toast. Run again, it writes nothing.
- `herdr-app do nav.ping` updates `nav.pong`.
- With Neovim split in two (`nvim -O a b`) beside a shell, focused in Neovim's left window:
  - `herdr-app do nav.right` moves Neovim to its right window;
  - `nav.right` again focuses the shell;
  - `nav.left` focuses Neovim again;
  - `nav.left` at the window's left edge does nothing.
- In insert mode, `nav.left` deletes a character and focus stays.
- Quick back-to-back presses inside Neovim land in order.
