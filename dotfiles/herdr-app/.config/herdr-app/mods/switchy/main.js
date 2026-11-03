// Switchy: fuzzy-find a space and go to it, after ~/.local/bin/mux-switchy.
// Type to filter the spaces; Enter goes to the highlighted one. When nothing
// matches, Enter resolves the query against the session mappings (built-in +
// ~/.tmux_session, `key=name` per line): exact key, else fuzzy key. The
// mapped space is selected, or made in ~ first if it doesn't exist. Below it,
// rows make a new space named after the query: here, or on each connected
// machine (`hc machine ls`), so a machine with no space is reachable by keyboard.
// Up: ↑, ctrl+k, ctrl+p. Down: ↓, ctrl+j, ctrl+n. Editing: backspace,
// alt+backspace (word), ctrl+u / cmd+backspace (all). ctrl+x closes the
// highlighted space. Esc leaves.

import { View, div, svg } from "gpui-kit";
import { v_flex, h_flex } from "gpui-base";
import { spaces, run, hc, theme, settings, props, closeOverlay, readTextFile, home, shared, setShared } from "herdr";

const MAPPINGS = { term: "🦄 term", obsidian: "📚 Obsidian", vpn: "🌈 vpn" };

// Space colors, as the shipped picker and spaces sidebar keep them.
const MARK = { ansi6: "#22a99a", ansi3: "#e3814f", ansi4: "#5b8def", ansi5: "#8b7cf6", ansi2: "#3fae6a", ansi1: "#d9649a" };
const PROJECT_COLORS = ["ansi6", "ansi3", "ansi4", "ansi5", "ansi2", "ansi1"];
function spaceColors() {
  const ids = new Set(spaces().map((p) => p.id));
  const kept = Object.fromEntries(Object.entries(shared("space.colors") ?? {}).filter(([id]) => ids.has(id)));
  let changed = Object.keys(kept).length !== Object.keys(shared("space.colors") ?? {}).length;
  for (const p of spaces()) {
    if (kept[p.id] || p.name === "~") continue;
    const uses = (c) => Object.values(kept).filter((v) => v === c).length;
    kept[p.id] = PROJECT_COLORS.reduce((best, c) => (uses(c) < uses(best) ? c : best));
    changed = true;
  }
  if (changed) setShared("space.colors", kept);
  return kept;
}
function spaceColor(t, p) {
  if (p.name === "~") return t.dim;
  const c = spaceColors()[p.id] ?? PROJECT_COLORS[0];
  return c.startsWith("#") ? c : (MARK[c] ?? t[c]);
}

// fzf-like: every query character in order, case-insensitive. Lower is better;
// null is no match. Contiguous and early matches win.
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

function bestMatch(items, query, key = (x) => x) {
  let best = null, bs = Infinity;
  for (const it of items) {
    const sc = score(key(it), query);
    if (sc !== null && sc < bs) (best = it), (bs = sc);
  }
  return best;
}

export default class Switchy extends View {
  init(_props, cx) {
    this.filter = "";
    this.at = null;
    this.scroll = 0;
    this.mappings = { ...MAPPINGS };
    this.machines = [];
    // Our own text field, not gpui-base's Input: its built-in bindings would
    // take ctrl+n/p/k before they reach us. One key handler does everything.
    this.handle = cx.focus_handle();
    this.handle.focus();
    cx.timer.after(600, () => this.handle.focus());
    cx.spawn(async (cx) => {
      try {
        const text = await readTextFile(`${home()}/.tmux_session`);
        for (const line of (text ?? "").split("\n")) {
          if (!line.trim() || line.trim().startsWith("#")) continue;
          const i = line.indexOf("=");
          if (i < 0) continue;
          const k = line.slice(0, i).trim(), v = line.slice(i + 1).trim();
          if (k && v) this.mappings[k] = v;
        }
      } catch {}
      cx.notify();
    });
    cx.spawn(async (cx) => {
      try {
        const r = await hc(["machine", "ls", "--json"]);
        if (r.code === 0) this.machines = (JSON.parse(r.stdout).machines ?? []).filter((m) => m.state === "connected" && !m.temporary).map((m) => m.name);
      } catch {}
      cx.notify();
    });
  }

  close() {
    closeOverlay(props().overlay);
  }

  // Rows: the matching spaces. When none match: the space the mappings name,
  // then a new space named after the query, here and on each connected machine.
  rows() {
    const f = this.filter.trim();
    const sorted = [...spaces()].sort((a, b) => a.name.localeCompare(b.name));
    const out = (!f ? sorted : sorted
      .map((p) => ({ p, s: score(p.name, f) }))
      .filter((y) => y.s !== null)
      .sort((a, b) => a.s - b.s)
      .map((y) => y.p)).map((p) => ({ kind: "space", p }));
    if (out.length || !f) return out;
    const name = this.mapped(f);
    if (name) out.push({ kind: "mapped", name });
    for (const machine of [null, ...this.machines]) {
      out.push({ kind: "new", machine, name: f, label: machine ? `new space "${f}" on ${machine}` : `new space "${f}"` });
    }
    return out;
  }

  // The space a query names through the mappings: exact key, else fuzzy key.
  mapped(query) {
    const q = query.trim();
    if (!q) return null;
    if (this.mappings[q]) return this.mappings[q];
    const key = bestMatch(Object.keys(this.mappings), q);
    return key ? this.mappings[key] : null;
  }

  go(row) {
    const r = row ?? this.rows()[this.at ?? 0];
    if (!r) return;
    this.close();
    if (r.kind === "space") run("space.select", { id: r.p.id });
    // Here it starts in ~, as mux-switchy; on a machine, in that machine's home.
    else if (r.kind === "new") run("space.new", r.machine ? { name: r.name, machine: r.machine } : { name: r.name, folder: home(), machine: "" });
    else if (r.kind === "mapped") {
      const found = spaces().find((p) => p.name === r.name);
      if (found) run("space.select", { id: found.id });
      else run("space.new", { name: r.name, folder: home(), machine: "" });
    }
  }

  glyph(t, st) {
    if (st === "working") return svg("mods/workspace-chrome/spinner.svg").size(12).flex_none().text_color(t.working).spin(900);
    return div().w(12).flex_none().text_color(t[st] ?? t.dim).child(st === "idle" ? "○" : st ? "●" : "·");
  }

  render() {
    const t = theme();
    const rows = this.rows();
    if (this.at === null) this.at = Math.max(0, rows.findIndex((r) => r.kind === "space" && r.p.active));
    this.at = Math.max(0, Math.min(this.at, rows.length - 1));

    // Fixed-height rows; the list scrolls only as far as keeps the selection in view.
    const H = 32;
    const height = Math.min(320, this.listHeight ?? 320);
    const total = Math.max(rows.length, 1) * H;
    const fixed = total > height;
    const maxScroll = Math.max(0, total - height);
    this.scroll = Math.max(0, Math.min(this.scroll, maxScroll));
    if (this.at * H < this.scroll) this.scroll = this.at * H;
    if ((this.at + 1) * H > this.scroll + height) this.scroll = (this.at + 1) * H - height;

    const row = (r, i) => {
      const on = i === this.at;
      const el = h_flex()
        .id(r.kind === "space" ? `sw-${r.p.id}` : r.kind === "new" ? `sw-new-${r.machine ?? "here"}` : "sw-mapped")
        .mx(4)
        .px(10)
        .h(H)
        .rounded(7)
        .gap(10)
        .items_center()
        .cursor_pointer()
        .when(on, (el) => el.bg(t.selected).text_color(t.foreground))
        .when(!on, (el) => el.hover((s) => s.bg(t.hover)))
        .on_click(() => this.go(r))
        .when(fixed, (el) => el.absolute().left(0).right(0).top(i * H - this.scroll));
      if (r.kind === "new" || r.kind === "mapped") {
        const exists = r.kind === "mapped" && spaces().some((p) => p.name === r.name);
        const label = r.kind === "new" ? r.label : `${exists ? "go to" : "new space"} ${r.name}`;
        return el
          .child(div().w(18).flex_none().text_color(t.dim).child(r.kind === "new" ? "+" : "↵"))
          .child(div().flex_1().truncate().text_color(on ? t.foreground : t.muted).child(label));
      }
      const p = r.p;
      return el
        .child(h_flex().size(18).flex_none().rounded(5).bg(spaceColor(t, p)).items_center().justify_center().text_size(10.5).font_bold().text_color("#ffffff").child([...p.name][0]?.toUpperCase() ?? "?"))
        .child(div().flex_1().truncate().text_color(t.foreground).when(p.active, (d) => d.font_semibold()).child(p.name))
        .when(!!p.machine, (el) => el.child(div().text_size(11).text_color(t.dim).child(p.machine)))
        .child(this.glyph(t, p.status));
    };

    const empty = h_flex().id("sw-empty").mx(4).px(10).h(H).items_center().text_color(t.dim).child("no match");

    return v_flex()
      .id("switchy")
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
        if (k === "enter") return this.go();
        if (k === "down" || (ctrl && (k === "j" || k === "n"))) { if (n) this.at = (this.at + 1) % n; }
        else if (k === "up" || (ctrl && (k === "k" || k === "p"))) { if (n) this.at = (this.at + n - 1) % n; }
        else if (ctrl && k === "x") {
          const sel = rows[this.at];
          if (sel?.kind === "space") run("space.close", { id: sel.p.id, confirmed: true });
        }
        else if ((ctrl && k === "u") || (cmd && k === "backspace")) setFilter("");
        else if ((alt && k === "backspace") || (ctrl && k === "w")) setFilter(this.filter.replace(/\S*\s*$/, ""));
        else if (k === "backspace") setFilter([...this.filter].slice(0, -1).join(""));
        else if (!ctrl && !cmd && e.key_char && e.key_char >= " ") setFilter(this.filter + e.key_char);
        else return;
        cx.stop_propagation();
        cx.notify();
      })
      .child(h_flex().items_center()
        .child(div().flex_1().text_size(15).font_semibold().text_color(t.foreground).child("Switch space"))
        .child(div().text_size(11).text_color(t.dim).child("⌃x close · Esc")))
      .child(
        h_flex().h(36).flex_none().px(10).gap(8).items_center().rounded(9).border_1().border_color(t.accent).bg(t.background)
          .child(svg("mods/workspace-chrome/search.svg").size(15).text_color(t.dim))
          .child(h_flex().flex_1().h_full().items_center().text_size(12.8).overflow_hidden()
            .when(!!this.filter, (el) => el.child(div().text_color(t.foreground).child(this.filter)))
            .child(div().w(1.5).h(16).flex_none().bg(t.accent).loop("opacity", { from: 0, to: 1, period: 1000 }))
            .when(!this.filter, (el) => el.child(div().pl(2).text_color(t.dim).child("Space…")))),
      )
      .child(
        v_flex()
          .id("sw-list")
          .on_size_change((size, cx) => { this.listHeight = size.height / settings().zoom; cx.notify(); })
          .h(Math.min(320, total))
          .min_h(0)
          .mb(6)
          .when(fixed, (el) => el.relative().overflow_hidden().on_scroll_wheel((e, cx) => {
            this.scroll = Math.max(0, Math.min(this.scroll - e.delta.y, maxScroll));
            this.at = Math.max(Math.ceil(this.scroll / H), Math.min(this.at, Math.floor((this.scroll + height) / H) - 1));
            cx.notify();
          }))
          .children(rows.length
            ? rows.map((r, i) => (!fixed || ((i + 1) * H > this.scroll && i * H < this.scroll + height) ? row(r, i) : null)).filter(Boolean)
            : [empty]),
      );
  }
}
