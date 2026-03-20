#import "lib.typ": *

#set page(..fig-page)
#set text(..fig-text)

#canvas(length: 0.48cm, {
  import draw: *

  // ── Palette ──
  let col-input  = rgb("#4e79a7")   // blue — input
  let col-core   = rgb("#59a14f")   // green — core
  let col-output = rgb("#e8a838")   // gold — output artifacts
  let col-human  = rgb("#f28e2b")   // orange — human feedback

  // ── Helpers ──
  let rbox(pos, w, h, col, name-id, title, ..details) = {
    rect(
      pos, (pos.at(0) + w, pos.at(1) - h),
      radius: 4pt,
      fill: col.lighten(80%),
      stroke: (thickness: 1.2pt, paint: col.darken(10%)),
      name: name-id,
    )
    let body = {
      text(7.5pt, weight: "bold", fill: black, title)
      for d in details.pos() {
        linebreak()
        text(6pt, fill: black, d)
      }
    }
    content(name-id, anchor: "center", body)
  }

  let arr = (end: "straight", scale: 0.35)
  let s = (thickness: 1pt, paint: black)
  let sh = (start: 0.08, end: 0.08)

  // ── Layout ──
  let bw = 7.0
  let bh = 2.2
  let bh-s = 1.8
  let cx = 8.0

  // ── Row 1: GitHub Issue ──
  let y1 = 0
  rbox((cx - bw / 2, y1), bw, bh, col-input, "issue",
    [GitHub Issue],
    [Formal definition · example],
    [Ground-truth solution])

  // ── Row 2: Example Database ──
  let y2 = y1 - bh - 1.8
  rbox((cx - bw / 2, y2), bw, bh, col-core, "exdb",
    [Example Database],
    [Canonical builder functions],
    [Single source of truth])

  // Arrow: Issue → Example DB
  line("issue", "exdb.north",
    stroke: s, mark: arr, shorten: sh, name: "e1")
  content((rel: (0.6, 0), to: "e1.mid"), anchor: "west",
    text(6pt, fill: black, [extract]))

  // ── Self-loop: Round-trip tests on Example Database (right side) ──
  let exdb-right = cx + bw / 2
  let exdb-mid-y = y2 - bh / 2
  bezier(
    (exdb-right, exdb-mid-y + 0.5),
    (exdb-right, exdb-mid-y - 0.5),
    (exdb-right + 2.5, exdb-mid-y + 1.2),
    (exdb-right + 2.5, exdb-mid-y - 1.2),
    stroke: (thickness: 1pt, paint: col-core.darken(20%)),
    mark: (end: "straight", scale: 0.35),
  )
  content(
    (exdb-right + 2.8, exdb-mid-y),
    anchor: "west",
    text(6pt, fill: col-core.darken(20%),
      align(center, [round-trip\ tests])),
  )

  // ── Row 3: Two outputs (JSON Fixtures and CLI) ──
  let y3 = y2 - bh - 2.0
  let out-w = 7.0
  let out-gap = 1.5
  let total = 2 * out-w + out-gap
  let x-start = cx - total / 2

  // Left: JSON Fixtures
  rbox((x-start, y3), out-w, bh-s, col-output, "json",
    [JSON Fixtures],
    [Source · target · solutions])

  // Right: CLI
  rbox((x-start + out-w + out-gap, y3), out-w, bh-s, col-input, "cli",
    [`pred create --example`],
    [Interactive exploration])

  // Arrows: Example DB → outputs
  line("exdb", "json.north",
    stroke: s, mark: arr, shorten: sh)
  line("exdb", "cli.north",
    stroke: s, mark: arr, shorten: sh)

  // ── Row 4: Typst PDF Manual (below JSON) ──
  let y4 = y3 - bh-s - 1.8
  let json-cx = x-start + out-w / 2
  rbox((json-cx - out-w / 2, y4), out-w, bh-s, col-output, "manual",
    [Typst PDF Manual],
    [Visual diagrams · proof sketches])

  // Arrow: JSON → Manual
  line("json.south", "manual.north",
    stroke: s, mark: arr, shorten: sh, name: "e5")
  content((rel: (0.6, 0), to: "e5.mid"), anchor: "west",
    text(6pt, fill: black, [render]))

  // ── Feedback: Manual → Issue (contributor cross-check) ──
  let fb-x = cx - bw / 2 - 2.5
  let issue-left = cx - bw / 2
  let manual-left = json-cx - out-w / 2
  let issue-mid-y = y1 - bh / 2
  let manual-mid-y = y4 - bh-s / 2

  line(
    (manual-left, manual-mid-y),
    (fb-x, manual-mid-y),
    (fb-x, issue-mid-y),
    (issue-left, issue-mid-y),
    stroke: (thickness: 1pt, paint: col-human, dash: "dashed"),
    mark: (end: "straight", scale: 0.35),
  )
  content(
    (fb-x - 0.3, (issue-mid-y + manual-mid-y) / 2),
    anchor: "east",
    text(6pt, fill: col-human,
      align(center, [contributor\ cross-check])),
  )
})
