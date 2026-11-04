# Nav

`ctrl+h/j/k/l` moves focus to the pane on the left, below, above or on the right, like vim-tmux-navigator. In a
Neovim pane the same keys first move between Neovim's own windows, and only leave Neovim at its edge. In insert mode
they keep their normal meaning (`ctrl+h` is still backspace). There is nothing to look at: the mod draws nothing, it
only moves focus.

Personal setup: the Neovim half lives in this repo's nvim package
(`dotfiles/nvim/.config/nvim/lua/util/mux_navigation.lua`, mapped in `lua/plugins/nvim-mux-navigation.lua`), and the
key bindings are in this package's `keys.json`.

## What you see

- Nothing is added to the window. The mod is a 0 px block in the layout and renders an empty `div()`.
- What changes is which pane has the keyboard: Herdr's focused-pane border (the layout's `focus` color) moves to the
  neighbouring pane, or Neovim's cursor moves to its neighbouring window.

## How it behaves

The keys are bound in `keys.json`'s `terminal` section (`ctrl-h` → `nav.left`, `ctrl-j` → `nav.down`, `ctrl-k` →
`nav.up`, `ctrl-l` → `nav.right`), so they act while a terminal has the keyboard. Each press runs one of:

| Focused terminal | What happens |
| --- | --- |
| A shell or any other program | `pane.go {direction}` |
| Neovim on this machine, with the label `nav.nvim` | Neovim is asked over its RPC socket: `nvim --server <socket> --remote-expr "v:lua.require'util.mux_navigation'.herdr('<h/j/k/l>')"`. Its answer decides what happens next. |
| ↳ answer `moved` | Neovim went to its window in that direction. Nothing else. |
| ↳ answer `edge` | No Neovim window that way: `pane.go {direction}`, but only if that terminal still has focus when the answer arrives |
| ↳ answer `passthrough` | Neovim is in insert, replace, command-line or terminal mode. It fed the key back to itself, so `ctrl+h` deletes a character and nothing moves. |
| ↳ no valid answer (socket gone, an nvim without the Lua module) | The key is typed in with `hc keys <terminal> ctrl+<key>` |
| vim, tmux, a Neovim on another machine (address `machine/t7`), or a Neovim without the label | The key is typed in with `hc keys <terminal> ctrl+<key>`, so the program handles it itself. A remote Neovim moves between its windows but never hands off to Herdr at its edge. |

- At the window's edge, with no pane in that direction, `pane.go` does nothing. There's no wrap-around.
- Presses to one Neovim run one after another, in order (a promise chain per terminal address).
- A local Neovim answers in about 50 ms (one `nvim --server` client per press).
- Agent statuses don't matter to it. No hover, clicks or animation.
- `herdr-app do nav.ping` makes the running copy write `Date.now()` to the shared key `nav.pong`, to check it receives
  commands.

## Built from

- **`mod.json`:** `{ "place": "none" }`. Herdr never docks it by itself.
- **The mount:** the layout on screen must hold a copy, as a 0 px block anywhere in its tree, for example the last
  child of a column: `{ "id": "nav", "type": "block", "size": { "px": 0 }, "content": { "mod": "nav" } }`.
  One copy per layout. Layouts aren't kept in this repo.
- **`main.js`**, one `View` with an empty `render()`. `init` runs a loop over `nextCommand()`: `left` / `down` /
  `up` / `right` / `ping`. Each command is handled without awaiting the previous one.
  - `herdr` functions used: `exec`, `focused`, `hc`, `nextCommand`, `run`, `setShared`, `terminals`.
  - The focused terminal comes from `focused().terminal`, and its program from `terminals()[i].foreground` (`name`,
    or the basename of `argv[0]`): `nvim`, `vim` or `tmux` want the key.
  - The socket is `terminals()[i].labels["nav.nvim"]`, used only when the address has no `/` (this machine) and the
    foreground is `nvim`.
  - `exec("nvim", ["--server", socket, "--remote-expr", …])` asks; `run("pane.go", { direction })` moves;
    `hc(["keys", address, "ctrl+h"])` is the fallback (not awaited).
- **What it needs from Neovim** (`util.mux_navigation`; the module name is written into `main.js`'s
  `--remote-expr`):
  - `advertise()`, run at startup: `hc label $HC_TERMINAL_ID nav.nvim=<v:servername>`, and on `VimLeavePre`
    `hc label … nav.nvim=` to remove it. Skipped inside tmux.
  - `herdr(key)`: return `"passthrough"` after feeding `<C-key>` back when `mode()` matches `^[iRct]`, else
    `"moved"` if `wincmd {key}` changed the current window, else `"edge"`. A `wincmd` error, as in the command-line
    window, counts as `"edge"`.
  - The normal-mode `<C-h/j/k/l>` mappings only run when a key was typed in with `hc keys`, and then just move
    between Neovim windows.
- **Programs it runs:** `nvim` (the RPC client) and `hc` (`hc keys`; `hc label` from Neovim). It reaches no network
  and reads or writes no files.

## Watch out

- **It only works where a layout mounts it.** `nav.left` is a `<mod>.<command>`, which reaches only a copy already
  running in the shown layout. Without the 0 px block the keys do nothing at all, with no error.
- **Don't add the block to Herdr's own layouts** (`main`, `terminals`, `win98`; `installed.json` lists them as
  `layout:<name>`). On the next start Herdr moves an edited one to `<name>-edited.json`, restores its own, and you're
  left on a layout without `nav`. Clone first (`herdr-app do layout.clone '{"name":"main","as":"main-nav"}'`, which
  keeps the clicks and switches to it), then add the block to the clone.
- **`place` isn't a way around that.** With `place` set, Herdr docks a new mod only while one of your own layouts is
  showing, and it restructures that file (it wraps the root in a new column).
- **Don't type keys into Neovim with `hc keys`.** `terminal.keys` holds input until nobody has typed for ~3 s. It was
  ~100 ms when idle, but seconds right after typing or a zoom. That's why a local Neovim is asked over RPC instead.
  vim, tmux and remote Neovim still go through `hc keys` and feel that delay.
- **Don't open a mod per key press** (`mod.open`): it's slow, and `mod.open` on a mod that's still open closes it, so
  quick presses get dropped.
- **Neovim needs a restart** to put its socket on its terminal. A Neovim started earlier gets `hc keys`.
- **Presses queue, they aren't dropped.** If Neovim is busy (a long command), presses wait for it. Each RPC call is
  limited by `exec`'s 30 s.
- **Taking the keys from programs:** in the `terminal` section these keys never reach shells or TUIs:
  `ctrl+h` (backspace), `ctrl+l` (clear), `ctrl+k` (kill line), `ctrl+j` (newline). Neovim keeps them in insert
  mode via `passthrough`; vim and tmux get them typed in.
- **Floats, zoomed panes and remote Neovim get no special handling.** In a Neovim float, `wincmd` decides the move.
  From a zoomed pane, whatever `pane.go` does. A Neovim on another machine never hands off at its edge.
- **Symlinked files don't hot-reload.** `~/.config/herdr-app/mods/nav/main.js` links into this repo, and Herdr watches
  the mod folder, not the link target. After editing here, re-create the link
  (`cd ~/.config/herdr-app/mods/nav && ln -sfn "$(readlink main.js)" main.js`) or restart Herdr.

## Done when

- `herdr-app check ~/.config/herdr-app/mods/nav` passes.
- `herdr-app do nav.ping` updates `shared("nav.pong")` (look in `shared.json`).
- In a tab with Neovim split in two (`nvim -O a b`) beside a shell, with Neovim focused in its left window:
  - `herdr-app do nav.right` moves Neovim to its right window, and Herdr's focus stays on Neovim;
  - the next `nav.right` moves Herdr's focus to the shell;
  - `nav.left` from the shell focuses Neovim;
  - `nav.left` at the left edge of the window changes nothing.
- The Neovim terminal has the label `nav.nvim` (`hc get <t> --json`), and it's gone after Neovim quits.
- In insert mode, after typing `xyz`, `nav.left` leaves `xy` and focus doesn't move.
- From Neovim's right window, `nav.left nav.right nav.left nav.right` sent back to back ends in the right window
  again, with Herdr's focus still on Neovim.
- Normal typing in shells and other panes still works; only `ctrl+h/j/k/l` are taken.
