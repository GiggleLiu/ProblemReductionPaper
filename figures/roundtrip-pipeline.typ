#import "lib.typ": *

#set page(..fig-page)
#set text(..fig-text)

#let unit = 0.34cm

#canvas(length: unit, {
  import draw: *

  // ── Role-based palette ──
  let col-input    = rgb("#4e79a7")   // blue: contributor input
  let col-core     = rgb("#59a14f")   // green: single source of truth
  let col-artifact = rgb("#e8a838")   // gold: generated artifact
  let col-verify   = rgb("#d45d5d")   // red: verification gate

  // ── Layout ──
  let bw = 7.0
  let bh = 5.0
  let inner-pad = 0.25cm

  // ── Box helper (variadic details, content auto-wraps via box(width)) ──
  let rbox(cx, cy, col, name-id, title, ..details) = {
    rect(
      (cx - bw / 2, cy + bh / 2),
      (cx + bw / 2, cy - bh / 2),
      radius: 3pt,
      fill: col.lighten(82%),
      stroke: (thickness: 1.0pt, paint: col.darken(15%)),
      name: name-id,
    )
    let body = align(center, {
      text(7.5pt, weight: "bold", fill: black, title)
      for d in details.pos() {
        linebreak()
        text(6pt, fill: black, d)
      }
    })
    content(
      (cx, cy),
      anchor: "center",
      box(width: bw * unit - inner-pad, body),
    )
  }

  // ── Stroke / arrow presets ──
  let arr = (end: "straight", scale: 0.35)
  let s   = (thickness: 0.9pt, paint: luma(40))
  let sh  = (start: 0.08, end: 0.08)

  // ── Column / row coordinates ──
  let y-mid =  0.0
  let y-top =  5.0
  let y-bot = -5.0

  let cx1 =  3.6
  let cx2 = 11.5
  let cx3 = 19.4
  let cx4 = 27.3
  let cx5 = 35.2

  // ── Middle spine ──
  rbox(cx1, y-mid, col-input, "issue",
    [GitHub Issue],
    [Formal definition · Example],
    [Ground-truth solution])

  rbox(cx2, y-mid, col-core, "exdb",
    [Example Database],
    [Canonical builder functions],
    [Single source of truth])

  rbox(cx5, y-mid, col-verify, "verify",
    [Verification],
    [Compare to the original issue])

  // ── Top branch ──
  rbox(cx3, y-top, col-artifact, "json",
    [JSON Fixtures],
    [Source · Target · Solutions])

  rbox(cx4, y-top, col-artifact, "manual",
    [Typst PDF Manual],
    [Visual diagrams · Proof sketches])

  // ── Bottom branch ──
  rbox(cx3, y-bot, col-artifact, "cli",
    [`pred create --example`],
    [Interactive exploration])

  // ── Arrows ──
  line("issue.east", "exdb.west", stroke: s, mark: arr, shorten: sh, name: "e-ext")
  content((rel: (0, 0.45), to: "e-ext.mid"), anchor: "south",
    text(5.5pt, fill: luma(40))[extract])

  // Fork from Example DB (orthogonal routing)
  let fork-x = (cx2 + cx3) / 2
  line("exdb.east", (fork-x, y-mid), (fork-x, y-top), "json.west",
    stroke: s, mark: arr, shorten: sh)
  line("exdb.east", (fork-x, y-mid), (fork-x, y-bot), "cli.west",
    stroke: s, mark: arr, shorten: sh)

  // Top branch: JSON → PDF Manual
  line("json.east", "manual.west", stroke: s, mark: arr, shorten: sh, name: "e-render")
  content((rel: (0, 0.45), to: "e-render.mid"), anchor: "south",
    text(5.5pt, fill: luma(40))[render])

  // Merge into Verification (both at x = merge-x, between PDF and Verify)
  let merge-x = (cx4 + cx5) / 2
  line("manual.east", (merge-x, y-top), (merge-x, y-mid), "verify.west",
    stroke: s, mark: arr, shorten: sh)
  line("cli.east", (merge-x, y-bot), (merge-x, y-mid), "verify.west",
    stroke: s, mark: arr, shorten: sh)
})
