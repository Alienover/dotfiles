# Nav

`ctrl+h/j/k/l` moves focus to the neighbouring pane, like vim-tmux-navigator. Inside Neovim the keys move between
Neovim's windows first and leave Neovim only at its edge. The mod draws nothing.

## Fresh install

Paste this to an agent running in Herdr:

> Run `~/src/dotfiles/dotfiles/herdr-app/.config/herdr-app/mods/nav/setup.sh` and tell me how it went. If it fails,
> read `mods/nav/RECIPE.md` next to it and fix what it reports.

Or run it yourself; Herdr must be open. It's safe to run again. It stops with a message at the first thing that fails.

What `setup.sh` does:

1. **Links the dotfiles:** `./setup herdr-app nvim`, so this mod, `keys.json` (which binds the keys) and the Neovim
   config are in `~/.config/`.
2. **Makes `main-nav`**, a copy of Herdr's `main`, unless it already exists. `nav` has to be in the layout on screen,
   but Herdr's own layouts can't be edited: on the next start Herdr moves an edited one aside and restores its own. A
   clone (`layout.clone`) is yours and keeps the layout's look. `setup.sh <layout>` copies another layout instead,
   e.g. `main-edited`, the name Herdr gives your old edited `main`.
3. **Adds `nav`** to `main-nav` if it isn't there yet: a 0 px block,
   `{"id":"nav","type":"block","size":{"px":0},"content":{"mod":"nav"}}`, at the end of the `work` column. This is
   the copy of `nav` that receives the keys.
4. **Switches to `main-nav` and checks it:**
   - `herdr-app status` shows `main-nav` with no errors;
   - `herdr-app check` passes on the mod;
   - `nav.ping` gets an answer.

Afterwards, restart any Neovim that was already running. Herdr never updates `main-nav`: to pick up a newer `main`,
delete `layouts/main-nav.json` and run `setup.sh` again.

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

## Done when

- `herdr-app check ~/.config/herdr-app/mods/nav` passes, and `herdr-app do nav.ping` updates `nav.pong`.
- With Neovim split in two (`nvim -O a b`) beside a shell, focused in Neovim's left window:
  - `herdr-app do nav.right` moves Neovim to its right window;
  - `nav.right` again focuses the shell;
  - `nav.left` focuses Neovim again;
  - `nav.left` at the window's left edge does nothing.
- In insert mode, `nav.left` deletes a character and focus stays.
- Quick back-to-back presses inside Neovim land in order.
