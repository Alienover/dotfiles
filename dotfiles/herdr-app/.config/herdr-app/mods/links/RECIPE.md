# Links

Open any link on the focused terminal's screen from the keyboard. `ctrl+shift+o` (Alacritty's default URL hint key)
pops up a list of the URLs on that terminal's screen, styled like the spaces sidebar: type to filter, Enter opens the
highlighted one in the browser.

## What you see

A 640 px popup at the top of the window (40 px down, at most 60% of its height), theme `popover`, 18 px padding:

1. **A filter field**, 36 px, `accent` border on `background`, a search icon, a blinking caret and `Link…` when empty.
   On the right, `shown/total` in `dim` 11 px.
2. **The links**, 32 px rows (at most 11 shown, then it scrolls with the selection), lowest on the screen first,
   so what just printed is on top and selected. Each row, like a space in the sidebar: an 18 px avatar (radius 5)
   with the host's first letter in white bold 10.5 px, colored by a hash of the host from the sidebar's palette
   (`#22a99a #e3814f #5b8def #8b7cf6 #3fae6a #d9649a`); the host (`www.` dropped) in `foreground`, semibold when
   selected, at most 220 px; the rest (path, query) in `dim` 11.5 px, truncated. Selected: `selected` background;
   others: `hover` on hover.
3. **A footer** in `dim` 11 px: `on t7` (the terminal read) and the keys.

Empty states: `Reading the screen…`, `No links on the screen`, `no match` (filter), or the error in `blocked`.

## How it behaves

- **Enter** opens the highlighted link with this computer's opener (`open`, `xdg-open`, `start`) and closes. A link
  without a scheme (`www.x.dev`) opens as `https://`.
- **ctrl+y** copies it, closes and shows a "Copied" toast.
- **↑ / ctrl+k / ctrl+p** and **↓ / ctrl+j / ctrl+n** move (wrapping). Typing filters fzf-style (every character in
  order); backspace, alt+backspace or ctrl+w (word), ctrl+u or cmd+backspace (all). **Esc** leaves. A click opens.
- A link from a terminal on another machine opens in the browser here.

## Built from

- **`mod.json`:** `{ "place": "none", "overlay": { "kind": "popup", "at": "top", "offset": 40, "width": 640,
  "height": 0.6 } }`, opened by `mod.open:links`. **`keys.json`:** `"ctrl-shift-o": "mod.open:links"` in `terminal`,
  the same key as Alacritty's default URL hints.
- **`main.js`:** one `View`, laid out and keyed like `switchy` (own focus handle, one `on_key_down`, fixed-height
  rows positioned by hand when the list scrolls).
  - In `init`: `focused().terminal` (the popup isn't a pane, so it's still the terminal), then `hc read <t>`.
  - `extract(text)`: lines bottom to top, each line's matches right to left, each URL once. Only links a browser
    opens: `https?://` or bare `www.` (no `ftp://`, `file://`, `mailto:`, `ssh:`). A URL stops where Alacritty's
    default hint regex stops it (control characters, whitespace, `<>"`, a backtick, `{|}`, `^`, `⟨⟩`, backslash),
    and at box drawing (`U+2500–259F`, TUI borders). Then, as Alacritty's post-processing, trailing `.,;:!?*`,
    unbalanced closing `)]` and an unmatched trailing `'` are dropped, repeatedly: `(see https://x.dev/a).` and
    `'https://x.dev/a'` give `https://x.dev/a`; `wiki/Foo_(bar)` and `wiki/O'Brien` stay whole.
  - `herdr` functions: `focused`, `hc`, `exec`, `theme`, `settings`, `props`, `closeOverlay`, `notify`, `window`
    (`platform` picks the opener). No network, no files.

## Watch out

- **Only the screen**, not scrollback: `hc read` with no `--lines`.
- `hc read` joins soft-wrapped lines, so a URL wrapped across rows comes back whole. A URL a program broke with its
  own newlines (hard wraps) is cut at the break.
- **OSC 8 hyperlinks** (text whose link isn't printed) come back as their label only: they aren't found.
- Under `herdr-app check` there's no `props().overlay`: it reads nothing.
- `main.js` links into this repo; Herdr watches the folder, not the link target. Re-create the link
  (`ln -sfn "$(readlink main.js)" main.js`) to reload an edit.

## Done when

- `herdr-app check` passes on `mods/links`.
- In a terminal that printed `https://github.com/folke/sidekick.nvim/pull/333.` and
  `(https://herdr.dev/mods)`, `ctrl+shift+o` lists `github.com /folke/sidekick.nvim/pull/333` and `herdr.dev /mods`
  without the `.` or `)`, the lowest one selected; Enter opens it in the browser, ctrl+y copies it, Esc closes.
