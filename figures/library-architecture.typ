#import "lib.typ": *

#set page(..fig-page)
#set text(..fig-text)

#canvas(length: 0.48cm, {
  import draw: *

  // ── Palette ──
  let col-cli     = rgb("#4e79a7")   // blue — user-facing
  let col-core    = rgb("#59a14f")   // green — core library
  let col-macro   = rgb("#e8a838")   // gold — compile-time

  // ── Helpers ──
  let layer-box(pos, w, h, col, name-id) = {
    rect(
      pos, (pos.at(0) + w, pos.at(1) - h),
      radius: 5pt,
      fill: col.lighten(85%),
      stroke: (thickness: 1.2pt, paint: col.darken(10%)),
      name: name-id,
    )
  }

  let ibox(pos, w, h, col, name-id, title, ..details) = {
    rect(
      pos, (pos.at(0) + w, pos.at(1) - h),
      radius: 3pt,
      fill: col.lighten(80%),
      stroke: (thickness: 0.8pt, paint: col.darken(10%)),
      name: name-id,
    )
    let body = {
      text(7pt, weight: "bold", fill: black, title)
      for d in details.pos() {
        linebreak()
        text(5.5pt, fill: black, d)
      }
    }
    content(name-id, anchor: "center", body)
  }

  // ── Layout ──
  let W = 22.0          // total width
  let m = 0.8           // margin inside layer boxes
  let g = 0.6           // gap between inner boxes
  let bw = (W - 2*m - 2*g) / 3   // inner box width ≈ 6.53
  let bh = 2.2          // inner box height

  // x-positions for 3-column grid
  let x1 = m
  let x2 = m + bw + g
  let x3 = m + 2*(bw + g)

  // ══════════════════════════════════════════
  // Layer 1: User Interfaces
  // ══════════════════════════════════════════
  let y1 = 0
  let h1 = 3.6
  layer-box((0, y1), W, h1, col-cli, "L1")
  content((m, y1 - 0.4), anchor: "west",
    text(8pt, weight: "bold", fill: black, [User Interfaces]))

  let uy = y1 - 1.0
  ibox((x1, uy), bw, bh, col-cli, "cli",
    [`pred` CLI],
    [create · path · solve · reduce])

  ibox((x2, uy), bw, bh, col-cli, "api",
    [Library API],
    [`use problemreductions::*`])

  ibox((x3, uy), bw, bh, col-cli, "manual",
    [PDF Manual],
    [Definitions · examples · proofs])

  // ══════════════════════════════════════════
  // Layer 2: Core Library
  // ══════════════════════════════════════════
  let y2 = y1 - h1 - 1.0
  let h2 = 6.6
  layer-box((0, y2), W, h2, col-core, "L2")
  content((m, y2 - 0.4), anchor: "west",
    text(8pt, weight: "bold", fill: black, [Core Library]))

  // Row 1
  let r1y = y2 - 1.0
  ibox((x1, r1y), bw, bh, col-core, "problems",
    [Problem Types],
    [`Problem` trait · `evaluate()`],
    [Size measures · complexity])

  ibox((x2, r1y), bw, bh, col-core, "rules",
    [Reduction Rules],
    [`ReduceTo<T>` trait],
    [Forward + inverse maps])

  ibox((x3, r1y), bw, bh, col-core, "graph",
    [Graph Engine],
    [Dijkstra path search],
    [Path composition])

  // Row 2
  let r2y = r1y - bh - g
  ibox((x1, r2y), bw, bh, col-core, "solvers",
    [Solvers],
    [Brute-force enumerator],
    [ILP: HiGHS / CBC / SCIP])

  ibox((x2, r2y), bw, bh, col-core, "symbolic",
    [Symbolic Engine],
    [Overhead & complexity],
    [Composition · comparison])

  ibox((x3, r2y), bw, bh, col-core, "exdb",
    [Example Database],
    [Canonical instances],
    [Ground-truth fixtures])

  // ══════════════════════════════════════════
  // Layer 3: Procedural Macros
  // ══════════════════════════════════════════
  let y3 = y2 - h2 - 1.0
  let h3 = 3.4
  layer-box((0, y3), W, h3, col-macro, "L3")
  content((m, y3 - 0.4), anchor: "west",
    text(8pt, weight: "bold", fill: black, [Compile-time Validation]))

  let my = y3 - 1.0
  ibox((x1, my), bw, bh, col-macro, "m-overhead",
    [Overhead Validation],
    [Symbolic expression parsing],
    [Variable name checking])

  ibox((x2, my), bw, bh, col-macro, "m-variants",
    [Type Registration],
    [Variant enumeration],
    [Complexity metadata])

  ibox((x3, my), bw, bh, col-macro, "m-checks",
    [Correctness Guards],
    [Getter method matching],
    [Expression well-formedness])

  // ══════════════════════════════════════════
  // Arrows between layers
  // ══════════════════════════════════════════
  let arr = (end: "straight", scale: 0.35)
  let s-down = (thickness: 1pt, paint: black)
  let s-up   = (thickness: 1pt, paint: black, dash: "dashed")
  let sh = (start: 0.06, end: 0.06)

  // Layer 1 → Layer 2 (three vertical arrows, centered on each column)
  let a1x = x1 + bw/2
  let a2x = x2 + bw/2
  let a3x = x3 + bw/2
  line((a1x, y1 - h1), (a1x, y2), stroke: s-down, mark: arr, shorten: sh)
  line((a2x, y1 - h1), (a2x, y2), stroke: s-down, mark: arr, shorten: sh)
  line((a3x, y1 - h1), (a3x, y2), stroke: s-down, mark: arr, shorten: sh)

  // Layer 3 → Layer 2 (dashed upward, compile-time injection)
  line((a1x, y3), (a1x, y2 - h2), stroke: s-up, mark: arr, shorten: sh)
  line((a2x, y3), (a2x, y2 - h2), stroke: s-up, mark: arr, shorten: sh)
  line((a3x, y3), (a3x, y2 - h2), stroke: s-up, mark: arr, shorten: sh)
})
