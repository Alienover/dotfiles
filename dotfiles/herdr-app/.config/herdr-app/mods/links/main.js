// Links: open a URL on the focused terminal's screen without the mouse.
// `mod.open:links` (ctrl+shift+o in keys.json, Alacritty's URL hint key) reads
// the screen of the terminal that had the keyboard (`hc read`, soft-wrapped
// lines come back joined) and lists its URLs, the lowest on screen first, as
// rows like the spaces sidebar:
// a colored avatar per host, the host, then the path dimmed.
// Type to filter. Enter opens the highlighted one and closes. ctrl+y copies
// it. Up: ↑, ctrl+k, ctrl+p.
// Down: ↓, ctrl+j, ctrl+n. Editing: backspace, alt+backspace / ctrl+w (word),
// ctrl+u / cmd+backspace (all). Esc leaves.

import { View, div, svg } from "gpui-kit";
import { v_flex, h_flex } from "gpui-base";
import { focused, hc, exec, theme, settings, props, closeOverlay, notify, window } from "herdr";

// The avatar colors of the spaces sidebar.
const MARK = ["#22a99a", "#e3814f", "#5b8def", "#8b7cf6", "#3fae6a", "#d9649a"];

// Links a browser opens: http(s), and bare www. (opened as https).
// Where a URL stops is Alacritty's default hint regex: control characters,
// whitespace, < > " ` { | } ^ ⟨ ⟩ and backslash. Plus box drawing
// (U+2500-259F): TUI borders such as │ sit right after a URL.
const URL_RE = /\b(?:https?:\/\/|www\.)[^\u0000-\u001F\u007F-\u009F\s<>"`{-}^⟨⟩\\─-▟]+/g;
const PAIRS = [["(", ")"], ["[", "]"]];
const count = (s, ch) => s.split(ch).length - 1;

// Trailing punctuation, unbalanced closing brackets and an unmatched quote
// belong to the text around the URL, as Alacritty's post-processing:
// "(see https://x.dev/a)." and "'https://x.dev/a'" give https://x.dev/a,
// while https://x.dev/O'Brien and https://x.dev/Foo_(bar) stay whole.
function clean(url) {
  let u = url;
  for (let before = ""; before !== u; ) {
    before = u;
    u = u.replace(/[.,;:!?*]+$/, "");
    for (const [open, close] of PAIRS) if (u.endsWith(close) && count(u, close) > count(u, open)) u = u.slice(0, -1);
    if (u.endsWith("'") && count(u, "'") % 2 === 1) u = u.slice(0, -1);
  }
  return u;
}

// URLs on the screen, the lowest first (what just printed), each once.
export function extract(text) {
  const seen = new Set(), out = [];
  for (const line of text.split("\n").reverse()) {
    const found = [...line.matchAll(URL_RE)].map((m) => clean(m[0])).reverse();
    for (const url of found) {
      if (url.length < 8 || seen.has(url)) continue;
      seen.add(url);
      out.push(url);
    }
  }
  return out;
}

function parts(url) {
  const m = url.match(/^(?:[a-z]+:\/\/)?([^/?#]*)(.*)$/i);
  const host = (m?.[1] || url).replace(/^www\./, "");
  return { host, rest: m?.[2] ?? "" };
}

function color(host) {
  let h = 0;
  for (const ch of host) h = (h * 31 + ch.codePointAt(0)) >>> 0;
  return MARK[h % MARK.length];
}

// fzf-like, as switchy: every query character in order, case-insensitive.
// Lower is better; null is no match. Contiguous and early matches win.
function score(text, query) {
  const s = text.toLowerCase(), q = query.toLowerCase().replace(/\s+/g, "");
  if (!q) return 0;
  const sub = s.indexOf(q);
  if (sub >= 0) return sub;
  let i = 0, first = -1, gaps = 0, last = -1;
  for (const ch of q) {
    const j = s.indexOf(ch, i);
    if (j < 0) return null;
    if (first < 0) first = j;
    if (last >= 0) gaps += j - last - 1;
    last = j;
    i = j + 1;
  }
  return 1000 + gaps * 10 + first;
}

// The system's opener, on this computer: a link from a remote terminal opens
// in the browser here.
function opener() {
  const p = window().platform;
  return p === "macos" ? ["open"] : p === "windows" ? ["cmd", "/c", "start", ""] : ["xdg-open"];
}

export default class Links extends View {
  init(_props, cx) {
    this.filter = "";
    this.at = 0;
    this.scroll = 0;
    this.urls = null; // null: still reading
    this.error = null;
    this.handle = cx.focus_handle();
    this.handle.focus();
    cx.timer.after(600, () => this.handle.focus());

    // The terminal that had the keyboard when this opened (a popup isn't a pane).
    this.terminal = focused()?.terminal ?? null;
    if (!props()?.overlay) return; // `herdr-app check`: nothing to read
    if (!this.terminal) {
      this.urls = [];
      this.error = "No terminal has the keyboard.";
      return;
    }
    cx.spawn(async (cx) => {
      try {
        const r = await hc(["read", this.terminal]);
        if (r.code !== 0) throw new Error((r.stderr || r.stdout).trim() || `hc read ${this.terminal} failed`);
        this.urls = extract(r.stdout);
      } catch (e) {
        this.urls = [];
        this.error = String(e?.message ?? e);
      }
      cx.notify();
    });
  }

  close() {
    closeOverlay(props().overlay);
  }

  rows() {
    const f = this.filter.trim();
    const urls = this.urls ?? [];
    if (!f) return urls;
    return urls
      .map((url, i) => ({ url, s: score(url, f), i }))
      .filter((y) => y.s !== null)
      .sort((a, b) => a.s - b.s || a.i - b.i)
      .map((y) => y.url);
  }

  open(url) {
    if (!url) return;
    this.close();
    const [cmd, ...args] = opener();
    // `www.x.dev` has no scheme: `open` would take it for a file
    const target = /^[a-z]+:\/\//i.test(url) ? url : `https://${url}`;
    exec(cmd, [...args, target]).then(
      (r) => r.code !== 0 && notify({ title: "Links", body: `${cmd} failed: ${(r.stderr || r.stdout).trim()}`, level: "error" }),
      (e) => notify({ title: "Links", body: `Couldn't run ${cmd}: ${e?.message ?? e}`, level: "error" }),
    );
  }

  copy(url, cx) {
    if (!url) return;
    cx.write_to_clipboard(url);
    this.close();
    notify({ title: "Copied", body: url, level: "info", timeout: 2500 });
  }

  render() {
    const t = theme();
    const rows = this.rows();
    this.at = Math.max(0, Math.min(this.at, rows.length - 1));

    // Fixed-height rows; the list scrolls only as far as keeps the selection in view.
    const H = 32;
    const height = Math.min(352, this.listHeight ?? 352);
    const total = Math.max(rows.length, 1) * H;
    const fixed = total > height;
    const maxScroll = Math.max(0, total - height);
    this.scroll = Math.max(0, Math.min(this.scroll, maxScroll));
    if (this.at * H < this.scroll) this.scroll = this.at * H;
    if ((this.at + 1) * H > this.scroll + height) this.scroll = (this.at + 1) * H - height;

    const row = (url, i) => {
      const on = i === this.at;
      const { host, rest } = parts(url);
      return h_flex()
        .id(`link-${i}-${url}`)
        .mx(4)
        .px(10)
        .h(H)
        .rounded(7)
        .gap(10)
        .items_center()
        .cursor_pointer()
        .when(on, (el) => el.bg(t.selected))
        .when(!on, (el) => el.hover((s) => s.bg(t.hover)))
        .on_click(() => this.open(url))
        .when(fixed, (el) => el.absolute().left(0).right(0).top(i * H - this.scroll))
        .child(h_flex().size(18).flex_none().rounded(5).bg(color(host)).items_center().justify_center().text_size(10.5).font_bold().text_color("#ffffff").child([...host][0]?.toUpperCase() ?? "?"))
        .child(div().flex_shrink(0).max_w(220).truncate().text_color(t.foreground).when(on, (d) => d.font_semibold()).child(host))
        .child(div().flex_1().min_w(0).truncate().text_size(11.5).text_color(t.dim).child(rest));
    };

    const message = this.urls === null ? "Reading the screen…" : this.error ?? (this.filter ? "no match" : "No links on the screen");
    const empty = h_flex().id("link-empty").mx(4).px(10).h(H).items_center().text_color(this.error ? t.blocked : t.dim).child(message);

    return v_flex()
      .id("links")
      .track_focus(this.handle)
      .w_full()
      .min_h(0)
      .p(18)
      .gap(10)
      .bg(t.popover)
      .text_size(13)
      .on_key_down((e, cx) => {
        const k = e.key, m = e.modifiers, n = rows.length;
        const ctrl = m.control, cmd = m.platform, alt = m.alt;
        const setFilter = (f) => { this.filter = f; this.at = 0; };
        if (k === "escape") return this.close();
        if (k === "enter") return this.open(rows[this.at]);
        if (ctrl && k === "y") return this.copy(rows[this.at], cx);
        if (k === "down" || (ctrl && (k === "j" || k === "n"))) { if (n) this.at = (this.at + 1) % n; }
        else if (k === "up" || (ctrl && (k === "k" || k === "p"))) { if (n) this.at = (this.at + n - 1) % n; }
        else if ((ctrl && k === "u") || (cmd && k === "backspace")) setFilter("");
        else if ((alt && k === "backspace") || (ctrl && k === "w")) setFilter(this.filter.replace(/\S*\s*$/, ""));
        else if (k === "backspace") setFilter([...this.filter].slice(0, -1).join(""));
        else if (!ctrl && !cmd && e.key_char && e.key_char >= " ") setFilter(this.filter + e.key_char);
        else return;
        cx.stop_propagation();
        cx.notify();
      })
      .child(
        h_flex().h(36).flex_none().px(10).gap(8).items_center().rounded(9).border_1().border_color(t.accent).bg(t.background)
          .child(svg("mods/workspace-chrome/search.svg").size(15).text_color(t.dim))
          .child(h_flex().flex_1().h_full().items_center().text_size(12.8).overflow_hidden()
            .when(!!this.filter, (el) => el.child(div().text_color(t.foreground).child(this.filter)))
            .child(div().w(1.5).h(16).flex_none().bg(t.accent).loop("opacity", { from: 0, to: 1, period: 1000 }))
            .when(!this.filter, (el) => el.child(div().pl(2).text_color(t.dim).child("Link…"))))
          .when((this.urls ?? []).length > 0, (el) => el.child(div().flex_none().text_size(11).text_color(t.dim).child(`${rows.length}/${this.urls.length}`))),
      )
      .child(
        v_flex()
          .id("link-list")
          .on_size_change((size, cx) => { this.listHeight = size.height / settings().zoom; cx.notify(); })
          .h(Math.min(352, total))
          .min_h(0)
          .when(fixed, (el) => el.relative().overflow_hidden().on_scroll_wheel((e, cx) => {
            this.scroll = Math.max(0, Math.min(this.scroll - e.delta.y, maxScroll));
            this.at = Math.max(Math.ceil(this.scroll / H), Math.min(this.at, Math.floor((this.scroll + height) / H) - 1));
            cx.notify();
          }))
          .children(rows.length
            ? rows.map((url, i) => (!fixed || ((i + 1) * H > this.scroll && i * H < this.scroll + height) ? row(url, i) : null)).filter(Boolean)
            : [empty]),
      )
      .child(h_flex().mx(4).px(10).justify_between().text_size(11).text_color(t.dim)
        .child(div().min_w(0).truncate().child(this.terminal ? `on ${this.terminal}` : ""))
        .child(div().flex_none().child("↵ open · ⌃y copy · Esc")));
  }
}
