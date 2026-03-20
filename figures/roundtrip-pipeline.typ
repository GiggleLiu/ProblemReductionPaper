#import "lib.typ": *

#set page(..fig-page)
#set text(..fig-text)

#canvas(length: 0.48cm, {
  import draw: *

  // ── Palette ──
  let col-input  = rgb("#4e79a7")   // blue — input
  let col-core   = rgb("#59a14f")   // green — core processing
  let col-output = rgb("#e8a838")   // gold — outputs
  let col-test   = rgb("#e15759")   // red — testing

  // ── Helpers ──
  let rbox(pos, w, h, col, name-id, title, ..details) = {
    rect(
      pos, (pos.at(0) + w, pos.at(1) - h),
      radius: 4pt,
      fill: col.lighten(88%),
      stroke: (thickness: 1pt, paint: col),
      name: name-id,
    )
    let body = {
      text(7.5pt, weight: "bold", fill: col.darken(15%), title)
      for d in details.pos() {
        linebreak()
        text(6pt, fill: luma(80), d)
      }
    }
    content(name-id, anchor: "center", body)
  }

  let arr = (end: "straight", scale: 0.35)
  let s = (thickness: 0.9pt, paint: luma(100))
  let sh = (start: 0.08, end: 0.08)

  let edge-label(pos, label) = {
    content(pos, anchor: "center",
      text(5.5pt, fill: luma(100), label))
  }

  // ── Layout ──
  let bw = 6.0    // box width
  let bh = 2.0    // box height
  let bh-s = 1.6  // small box height

  // ── Stage 1: Issue (top-left) ──
  rbox((0, 0), bw, bh, col-input, "issue",
    [GitHub Issue],
    [Formal definition · example instance],
    [Ground-truth solution])

  // ── Stage 2: Example DB (center) ──
  let cx = 9.0
  rbox((cx, 0), bw, bh, col-core, "exdb",
    [Example Database],
    [Canonical builder functions],
    [`model_builders.rs` · `rule_builders.rs`])

  // Arrow: Issue → Example DB
  line("issue.east", "exdb.west",
    stroke: s, mark: arr, shorten: sh, name: "e1")
  edge-label("e1.mid", [extract])

  // ── Stage 3: Three parallel outputs ──
  let out-x = cx + bw + 4.0
  let out-w = 6.5
  let spread = 3.0

  // Output 1: Round-trip tests (top)
  rbox((out-x, spread), out-w, bh-s, col-test, "tests",
    [Round-trip Tests],
    [Closed-loop verification for every rule])

  // Output 2: JSON fixtures → PDF manual (middle)
  rbox((out-x, -0.2), out-w, bh-s, col-output, "json",
    [JSON Fixtures],
    [Source · target · overhead · solutions])

  rbox((out-x + out-w + 2.5, -0.2), 5.0, bh-s, col-output, "manual",
    [Typst PDF Manual],
    [Visual diagrams · proof sketches])

  // Output 3: CLI examples (bottom)
  rbox((out-x, spread - 2 * spread), out-w, bh-s, col-input, "cli",
    [`pred create --example`],
    [Interactive exploration via CLI])

  // ── Arrows: Example DB → outputs ──
  line("exdb.east", "tests.west",
    stroke: s, mark: arr, shorten: sh, name: "e2")

  line("exdb.east", "json.west",
    stroke: s, mark: arr, shorten: sh, name: "e3")

  line("exdb.east", "cli.west",
    stroke: s, mark: arr, shorten: sh, name: "e4")

  // Arrow: JSON → Manual
  line("json.east", "manual.west",
    stroke: s, mark: arr, shorten: sh, name: "e5")
  edge-label("e5.mid", [render])
})
