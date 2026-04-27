#import "lib.typ": *
#import "@preview/pixel-family:0.2.0": bob, grace, crank, sentinel

#set page(width: auto, height: auto, margin: 6pt)
#set text(size: 7.5pt, font: "Helvetica")

// ── Panel-specific palette ──
#let col-p1   = rgb("#4e79a7")   // blue
#let col-p2   = rgb("#f28e2b")   // orange
#let col-p3   = rgb("#59a14f")   // green
#let col-red  = rgb("#e15759")
#let col-violet = rgb("#b07aa1")
#let col-teal = rgb("#76b7b2")

// ── Panel chrome parameters ──
#let panel-stroke = (thickness: 0.7pt, paint: luma(180))
#let panel-fill(col) = col.lighten(95%)
#let panel-radius = 6pt

// Icon placeholder: dashed-edge rounded square we fill in later with artwork.
#let icon-slot(w: 1.2cm, h: 1.2cm, label: none) = box(
  width: w, height: h,
  stroke: (thickness: 0.4pt, paint: luma(180), dash: "dashed"),
  radius: 3pt,
  inset: 2pt,
  align(center + horizon, text(5pt, fill: luma(150),
    if label == none { [icon] } else { label })),
)

// Small tile for an NP-hard problem type (icon on top, caption below).
#let problem-tile(label, icon: none) = align(center)[
  #if icon == none {
    icon-slot(w: 1.0cm, h: 1.0cm, label: [ ])
  } else {
    icon
  }
  #v(-5pt)
  #text(6.5pt, weight: "regular", fill: fg, label)
]

// Solver-format box (icon on the left, two-line label on the right).
#let solver-box(label, sub, icon: none, col: col-p2, w: 3.3cm) = box(
  width: w,
  stroke: (thickness: 0.7pt, paint: col),
  radius: 4pt,
  inset: 5pt,
  fill: white,
)[
  #std.grid(
    columns: (0.9cm, 1fr),
    gutter: 4pt,
    align: (center + horizon, left + horizon),
    if icon == none { icon-slot(w: 0.8cm, h: 0.7cm, label: [ ]) } else { icon },
    [
      #text(8pt, weight: "bold", fill: col.darken(10%), label) \
      #text(6pt, fill: fg-light, sub)
    ],
  )
]

// Section header inside a panel: thin divider + centered caption.
#let panel-section(label, col) = align(center)[
  #text(7.5pt, weight: "bold", fill: col.darken(10%), label)
]

// Vertical flow connector — longer shaft, smaller head than the text glyph.
#let flow-arrow(color: black, h: 18pt) = align(center,
  canvas(length: 1pt, {
    import draw: *
    let s = h / 1pt
    line((0, s), (0, 0),
      stroke: (paint: color, thickness: 1.4pt, cap: "round"),
      mark: (end: "stealth", scale: 0.5, fill: color))
  })
)

// ─────────────────────────────────────────────────────────────
// Panel 1: Many hard problems, many solver formats
// ─────────────────────────────────────────────────────────────
#let panel1(h: auto) = box(
  width: 6.7cm,
  height: h,
  stroke: panel-stroke,
  radius: panel-radius,
  fill: panel-fill(col-p1),
  inset: 10pt,
)[
  // Header: numbered circle + bold title
  #std.grid(
    columns: (0.9cm, 1fr),
    gutter: 6pt,
    align: (center + horizon, left + horizon),
    box(width: 0.8cm, height: 0.8cm,
      stroke: (thickness: 1.2pt, paint: col-p1),
      radius: 50%, fill: white,
      align(center + horizon, text(13pt, weight: "bold", fill: col-p1, [1]))),
    text(11pt, weight: "bold", fill: col-p1.darken(10%),
      [Many hard problems,\ many solver formats]),
  )

  #v(8pt)
  #panel-section([NP-hard problem types], col-p1)
  #v(4pt)

  // 3 × 3 grid of problem tiles (last row has only "Bin Packing" and "…").
  #std.grid(
    columns: (1fr, 1fr, 1fr),
    rows: (auto, auto, auto),
    gutter: 6pt,
    problem-tile([3-SAT], icon: image("icons/3sat.svg", width: 1.4cm)),
    problem-tile([Max-Cut], icon: image("icons/max-cut.svg", width: 1.4cm)),
    problem-tile([Set Cover], icon: image("icons/set-cover.svg", width: 1.4cm)),
    problem-tile([K-Coloring], icon: image("icons/k-coloring.svg", width: 1.4cm)),
    problem-tile([TSP], icon: image("icons/tsp.svg", width: 1.4cm)),
    problem-tile([MIS], icon: image("icons/mis.svg", width: 1.4cm)),
    problem-tile([Bin Packing], icon: image("icons/bin-packing.svg", width: 1.4cm)),
    problem-tile([Partition], icon: image("icons/partition.svg", width: 1.4cm)),
    align(center + horizon, text(14pt, fill: fg-light, [$dots$])),
  )

  #v(6pt)
  #line(length: 100%, stroke: (thickness: 0.4pt, paint: luma(200), dash: "dashed"))
  #v(3pt)
  #align(center, text(6.5pt, fill: fg-light,
    [Each backend takes its own format;\ problems must be encoded to fit.]))
  #v(3pt)
  #line(length: 100%, stroke: (thickness: 0.4pt, paint: luma(200), dash: "dashed"))
  #panel-section([Solver formats / backends], col-p2)
  #v(4pt)

  // 2×2 grid: (SAT, ILP) ; (Annealer, …).
  #std.grid(
    columns: (1fr, 1fr),
    rows: (auto, auto),
    gutter: 5pt,
    solver-box([SAT], [CNF formula], icon: image("icons/sat-solver.svg", width: 0.85cm), col: col-p2, w: 100%),
    solver-box([ILP], [$A x ≤ b, x in ZZ^n$], icon: image("icons/ilp-solver.svg", width: 0.85cm), col: col-p2, w: 100%),
    solver-box([Annealer], [QUBO / Ising], icon: image("icons/annealer.svg", width: 0.85cm), col: col-p2, w: 100%),
    align(center + horizon, text(14pt, fill: fg-light, [$dots$])),
  )

]

// ─────────────────────────────────────────────────────────────
// Panel 2: Harness-engineered agentic integration
// ─────────────────────────────────────────────────────────────

// Rounded card: title line, multi-line body, accent bar on left.
#let agent-card(col, title, body, icon: none) = box(
  width: 100%,
  stroke: (thickness: 0.9pt, paint: col),
  radius: 5pt,
  fill: white,
  inset: 6pt,
)[
  #std.grid(
    columns: (0.9cm, 1fr),
    gutter: 5pt,
    align: (center + horizon, left + horizon),
    if icon == none { icon-slot(w: 0.8cm, h: 0.8cm, label: [bot]) } else { icon },
    [
      #text(8pt, weight: "bold", fill: col.darken(10%), title) \
      #text(6.3pt, fill: fg-light, body)
    ],
  )
]

// Small status pill (e.g. "Open" badge).
#let issue-pill(label, col) = box(
  fill: col,
  radius: 6pt,
  inset: (x: 1pt, y: 2pt),
  text(5.8pt, weight: "bold", fill: white, label),
)

// Tag chip (GitHub-style label).
#let issue-chip(label, col) = box(
  fill: col.lighten(80%),
  stroke: (thickness: 0.4pt, paint: col.lighten(40%)),
  radius: 8pt,
  inset: (x: 4pt, y: 1pt),
  text(5.6pt, fill: col.darken(20%), label),
)

// GitHub issue card — mimics a real issue panel.
#let github-card = box(
  width: 100%,
  stroke: (thickness: 0.7pt, paint: luma(180)),
  radius: 5pt,
  fill: white,
  clip: true,
)[
  #set block(spacing: 0pt)
  #set par(spacing: 0pt)
  // Header strip (GitHub-like: light gray bar with icon + repo path).
  #box(
    width: 100%,
    fill: luma(245),
    stroke: (bottom: (thickness: 0.5pt, paint: luma(200))),
    inset: (x: 6pt, y: 2pt),
  )[
    #std.grid(
      columns: (auto, 1fr, auto),
      gutter: 4pt,
      align: horizon,
      image("icons/github.svg", width: 0.42cm),
      text(6.5pt, fill: fg-light)[
        problem-reductions
      ],
      text(6.2pt, fill: fg-light, [#sym.dot.c #sym.dot.c #sym.dot.c]),
    )
  ]

  #v(2pt)
  // Body
  #block(inset: (x: 7pt, y: 5pt))[
    #set block(spacing: 0pt)
    #set par(spacing: 0pt)
    // Title line: status pill + title + issue number
    #std.grid(
      columns: (18pt, auto),
      gutter: 3pt,
      align: (left + top, left + top),
      issue-pill([Open], rgb("#2da44e")),
      [
        #text(8.2pt, weight: "bold", fill: fg,
          [[Rule] K-Coloring #sym.arrow ILP])
        // #h(3pt)
        // #text(8.2pt, fill: fg-light, [#024])
      ],
    )

    #v(2pt)

    // Meta line: author + opened time
    // #text(5.8pt, fill: fg-light)[
    //   #box(
    //     width: 0.34cm, height: 0.34cm,
    //     radius: 50%,
    //     fill: col-p2.lighten(60%),
    //     baseline: 1.5pt,
    //   )
    //   #h(1pt) *\@alice* opened this issue 2 days ago #sym.dot.c 0 comments
    // ]

    // #v(4pt)
    // #line(length: 100%, stroke: (thickness: 0.3pt, paint: luma(220)))
    // #v(4pt)

    #v(4pt)
    #line(length: 100%, stroke: (thickness: 0.3pt, paint: luma(220)))
    #v(4pt)

    // Issue-template fields: left labels / right values
    // (mirrors .github/ISSUE_TEMPLATE/rule.md — Source/Target are in the title).
    #std.grid(
      columns: (auto, 1fr),
      column-gutter: 10pt,
      row-gutter: 4pt,
      align: (left + top, left + top),
      text(6.2pt, fill: fg-light, [Algorithm]),
        text(6.4pt, fill: fg,
          [$x_(v,c) in {0,1}$; one-hot per $v$; $x_(u,c) + x_(v,c) <= 1$ on edges]),
      text(6.2pt, fill: fg-light, [Overhead]),
        text(6.4pt, fill: fg, [variables $|V| dot k$,\ constraints $|E| dot k + |V|$]),
        text(6.2pt, fill: fg-light, [Reference]),
      text(6.4pt, fill: fg, [Mehrotra & Trick, 1996]),
       text(6.2pt, fill: fg-light, [Example]),
        text(6.4pt, fill: fg, [
          ...
        ]),
    )

    #v(2pt)

    // Label chips
    // #std.grid(
    //   columns: (auto, auto, auto, 1fr),
    //   gutter: 3pt,
    //   align: (left + horizon,) * 4,
    //   issue-chip([enhancement], rgb("#0969da")),
    //   issue-chip([reduction], col-p3),
    //   issue-chip([no-code], col-violet),
    //   [],
    // )
  ]
]

// Verification harness box: 4 mini-cards in a row.
#let verif-cell(label, icon: none) = box(
  width: 100%, height: 1.3cm,
  stroke: (thickness: 0.6pt, paint: col-violet),
  radius: 3pt,
  fill: white,
  inset: 3pt,
)[
  #align(center + top)[
    #if icon == none { icon-slot(w: 0.5cm, h: 0.5cm, label: [ ]) } else { icon }
    #v(3pt)
    #text(5.8pt, fill: col-violet.darken(20%), weight: "regular", align(center, label))
  ]
]

// Harness container — wraps the two agents in a feedback loop, with the
// 4 verification layers as a base strip below.
#let harness-box = box(
  width: 100%,
  stroke: (thickness: 0.9pt, paint: col-violet),
  radius: 5pt,
  fill: col-violet.lighten(92%),
  inset: 4pt,
)[
  #set block(spacing: 0pt)
  #set par(spacing: 0pt)

  // Title
  #std.grid(
    columns: (auto, 1fr),
    gutter: 5pt,
    align: (center + horizon, left + horizon),
    image("icons/loop.svg", width: 0.5cm),
    text(8.5pt, weight: "bold", fill: col-violet.darken(15%),
      [Agents under harness]),
  )

  #v(6pt)

  // Implementation agent
  #agent-card(col-p1, [Implementation Agent],
    [Plan #sym.arrow Encode #sym.arrow Generate code \
     Propose reduction rule],
    icon: image("icons/agent-impl.svg", width: 1cm))

  #flow-arrow()

  // Review agent
  #agent-card(col-p3, [Review Agent],
    [Static analysis #sym.arrow Semantics check \
     Approve or request changes],
    icon: image("icons/agent-review.svg", width: 1cm))

  #v(6pt)
  #line(length: 100%,
    stroke: (thickness: 0.4pt, paint: col-violet.lighten(40%), dash: "dashed"))
  #v(6pt)

  // 4 verification layers — base strip
  #std.grid(
    columns: (1fr, 1fr, 1fr, 1fr),
    gutter: 3pt,
    verif-cell([*compile-time checks*], icon: image("icons/type-check.svg", height: 0.5cm)),
    verif-cell([*automated unit tests*], icon: image("icons/unit-tests.svg", height: 0.5cm)),
    verif-cell([*round-trip verifications*], icon: image("icons/round-trip.svg", height: 0.5cm)),
    verif-cell([*agentic feature tests*], icon: image("icons/agent-user.svg", height: 0.5cm)),
  )
]

#let panel2(h: auto) = box(
  width: 7.2cm,
  height: h,
  stroke: panel-stroke,
  radius: panel-radius,
  fill: panel-fill(col-p2),
  inset: 10pt,
)[
  #set block(spacing: 0pt)
  #set par(spacing: 0pt)

  // Header
  #std.grid(
    columns: (0.9cm, 1fr),
    gutter: 6pt,
    align: (center + horizon, left + horizon),
    box(width: 0.8cm, height: 0.8cm,
      stroke: (thickness: 1.2pt, paint: col-p2),
      radius: 50%, fill: white,
      align(center + horizon, text(13pt, weight: "bold", fill: col-p2, [2]))),
    text(11pt, weight: "bold", fill: col-p2.darken(10%),
      [Harness-engineered\ agentic integration]),
  )

  #v(15pt)

  // Person-at-laptop (left) and GitHub issue card (right).
  #std.grid(
    columns: (1.6cm, 1fr),
    gutter: 5pt,
    align: (center + horizon, left + horizon),
    [
      #icon-slot(w: 1.4cm, h: 1.4cm, label: [person\ at laptop])
      #v(3pt)
      #text(5.5pt, style: "italic", fill: col-p3.darken(10%),
        align(center, [no-code\ contribution\ route]))
    ],
    github-card,
  )

  // Issue → harness
  #flow-arrow()

  #harness-box

  // Harness → validated code
  #flow-arrow()

  #box(
    width: 100%,
    stroke: (thickness: 0.9pt, paint: col-p3),
    radius: 5pt,
    fill: col-p3.lighten(92%),
    inset: 6pt,
  )[
    #std.grid(
      columns: (auto, 1fr),
      gutter: 6pt,
      align: (center + horizon, left + horizon),
      icon-slot(w: 0.55cm, h: 0.55cm, label: [`</>`]),
      [
        #text(8.5pt, weight: "bold", fill: col-p3.darken(15%),
          [Validated Reduction Code]) \
        #text(6.3pt, fill: fg-light, [Merged into the reduction library])
      ],
    )
  ]
]

// ─────────────────────────────────────────────────────────────
// Panel 3: A reduction graph built at scale
// ─────────────────────────────────────────────────────────────

// Small statistic tile for the right rail.
#let stat-tile(value, label, icon-label: [ ]) = box(
  width: 100%,
  stroke: (thickness: 0.6pt, paint: luma(180)),
  radius: 4pt,
  fill: white,
  inset: 5pt,
)[
  #std.grid(
    columns: (0.7cm, 1fr),
    gutter: 5pt,
    align: (center + horizon, left + horizon),
    icon-slot(w: 0.6cm, h: 0.6cm, label: icon-label),
    [
      #text(10pt, weight: "bold", fill: fg, value) \
      #text(6pt, fill: fg-light, label)
    ],
  )
]

// Real reduction graph: 155 problem types + 241 reduction edges from
// data/reduction-graph-layout.json (built by Graphviz `sfdp` with prism
// overlap-removal in scripts/build-reduction-graph-layout.py). Only the
// two hubs — 3-SAT and ILP — carry text labels.
#let reduction-graph-real = {
  let data = json("../data/reduction-graph-layout.json")
  let hubs = ("KSatisfiability", "ILP")

  let category-color(c) = {
    if c == "graph" { col-p1 }
    else if c == "formula" { col-p3 }
    else if c == "set" { col-red }
    else if c == "algebraic" { col-violet }
    else { col-teal }
  }

  let plot-w = 11.0
  let plot-h = 16.0
  let r-node = 0.16
  let r-hub  = 0.26
  let edge-stroke = (thickness: 0.22pt, paint: rgb(120, 120, 130, 70))
  let edge-curve = 0.18

  // Percentile-based bounds (clip outliers) so the bulk of the graph
  // fills the canvas instead of being compressed by a few far points.
  let xs-sorted = data.nodes.map(n => n.x).sorted()
  let ys-sorted = data.nodes.map(n => n.y).sorted()
  let pct(arr, p) = arr.at(
    calc.min(arr.len() - 1, calc.max(0, int(p * arr.len()))))
  let x-min = pct(xs-sorted, 0.02)
  let x-max = pct(xs-sorted, 0.98)
  let y-min = pct(ys-sorted, 0.02)
  let y-max = pct(ys-sorted, 0.98)
  let pad = 0.04
  let clamp-v(v, lo, hi) = calc.max(lo, calc.min(hi, v))
  let nx-pos(x) = pad * plot-w
    + clamp-v((x - x-min) / (x-max - x-min), 0.0, 1.0) * (1 - 2 * pad) * plot-w
  let ny-pos(y) = pad * plot-h
    + clamp-v((y - y-min) / (y-max - y-min), 0.0, 1.0) * (1 - 2 * pad) * plot-h

  let name-to-pos = (:)
  for n in data.nodes {
    name-to-pos.insert(n.name, (nx-pos(n.x), ny-pos(n.y)))
  }
  let is-hub(name) = name in hubs

  canvas(length: 0.36cm, {
    import draw: *

    // Edges (back layer) — quadratic bezier with slight perpendicular bow.
    for e in data.edges {
      let (px, py) = name-to-pos.at(e.source)
      let (qx, qy) = name-to-pos.at(e.target)
      let dx = qx - px
      let dy = qy - py
      let len = calc.sqrt(dx * dx + dy * dy)
      if len < 0.01 { continue }
      let ux = dx / len
      let uy = dy / len
      let r-src = if is-hub(e.source) { r-hub } else { r-node }
      let r-tgt = if is-hub(e.target) { r-hub } else { r-node }
      let sx = px + ux * r-src
      let sy = py + uy * r-src
      let tx = qx - ux * r-tgt
      let ty = qy - uy * r-tgt
      let mx = (sx + tx) / 2
      let my = (sy + ty) / 2
      let bow = edge-curve * len * 0.5
      bezier(
        (sx, sy), (tx, ty),
        (mx + (-uy) * bow, my + ux * bow),
        stroke: edge-stroke,
      )
    }

    // Ordinary nodes
    for n in data.nodes {
      if is-hub(n.name) { continue }
      let col = category-color(n.category)
      circle(
        name-to-pos.at(n.name),
        radius: r-node,
        fill: col.lighten(35%),
        stroke: (thickness: 0.25pt, paint: col.darken(15%)),
      )
    }

    // Hubs — slightly bigger filled disk + label OUTSIDE.
    for n in data.nodes {
      if not is-hub(n.name) { continue }
      let col = category-color(n.category)
      let label = if n.name == "KSatisfiability" { [3-SAT] } else { [ILP] }
      let (cx, cy) = name-to-pos.at(n.name)
      circle(
        (cx, cy),
        radius: r-hub,
        fill: col.darken(5%),
        stroke: (thickness: 0.4pt, paint: col.darken(20%)),
      )
      let dy-off = if n.name == "KSatisfiability" { 0.55 } else { -0.55 }
      let anchor = if n.name == "KSatisfiability" { "south" } else { "north" }
      content(
        (cx, cy + dy-off),
        anchor: anchor,
        text(7pt, weight: "bold", fill: col.darken(25%), label),
      )
    }
  })
}

// Mini growth-over-time curve — same schematic style as the original mockup,
// now driven by the project's real weekly counts (problem types vs reduction
// rules). Phase boundaries on the chart sit at their true week positions;
// the bottom phase strip is evenly spaced for readability.
#let growth-mini = canvas(length: 0.3cm, {
  import draw: *

  // Real weekly data: (week index, count).
  let data-models = (
    (0, 17), (2, 20), (3, 20), (4, 20), (5, 21),
    (6, 21), (7, 23), (8, 23), (9, 39), (10, 107), (11, 116),
    (12, 187), (13, 187),
  )
  let data-rules = (
    (0, 0), (2, 21), (3, 24), (4, 35), (5, 45),
    (6, 52), (7, 52), (8, 52), (9, 56), (10, 73), (11, 153),
    (12, 214), (13, 239),
  )
  let phase2 = 7
  let phase3 = 8.5

  // Plot frame in canvas units.
  let x-min  = 0
  let x-max  = 13.5
  let y-max  = 260
  let plot-w = 26.0
  let plot-h = 5.5
  let x0 = 0.0
  let y0 = 0.0

  // Data → canvas coords.
  let sx(w) = x0 + (w - x-min) / (x-max - x-min) * plot-w
  let sy(c) = y0 + c / y-max * plot-h
  let pt(p) = (sx(p.at(0)), sy(p.at(1)))

  // Phase boundaries — dashed verticals at the REAL week positions.
  line((sx(phase2), y0), (sx(phase2), y0 + plot-h),
    stroke: (thickness: 0.4pt, paint: luma(170), dash: "dashed"))
  line((sx(phase3), y0), (sx(phase3), y0 + plot-h),
    stroke: (thickness: 0.4pt, paint: luma(170), dash: "dashed"))

  // Both filled areas are drawn first (background layer), then both line
  // strokes and point markers on top — otherwise a later fill would occlude
  // an earlier line.
  let rules-pts = data-rules.map(pt)
  let rules-fill = rules-pts + (
    (rules-pts.last().at(0),  y0),
    (rules-pts.first().at(0), y0),
  )
  let models-pts = data-models.map(pt)
  let models-fill = models-pts + (
    (models-pts.last().at(0),  y0),
    (models-pts.first().at(0), y0),
  )

  // Fills (back layer).
  merge-path(close: true, fill: col-red.lighten(80%), stroke: none, {
    line(..rules-fill)
  })
  merge-path(close: true, fill: col-p1.lighten(80%), stroke: none, {
    line(..models-fill)
  })

  // Strokes and points (front layer).
  line(..rules-pts, stroke: (thickness: 1.2pt, paint: col-red.darken(5%)))
  line(..models-pts, stroke: (thickness: 1.2pt, paint: col-p1.darken(5%)))
  for p in rules-pts {
    circle(p, radius: 0.18, fill: white,
      stroke: (thickness: 0.7pt, paint: col-red.darken(5%)))
  }
  for p in models-pts {
    circle(p, radius: 0.18, fill: white,
      stroke: (thickness: 0.7pt, paint: col-p1.darken(5%)))
  }

  // X- and Y-axis with arrow heads at the ends.
  line((x0, y0), (x0 + plot-w + 0.5, y0),
    stroke: (thickness: 0.6pt, paint: fg),
    mark: (end: "straight", scale: 0.3))
  line((x0, y0), (x0, y0 + plot-h + 0.5),
    stroke: (thickness: 0.6pt, paint: fg),
    mark: (end: "straight", scale: 0.3))

  // Y-axis tick marks + labels (0, 100, 200 — data peaks at 239).
  for tv in (100, 200) {
    let ty = sy(tv)
    line((x0 - 0.18, ty), (x0, ty),
      stroke: (thickness: 0.5pt, paint: fg))
    content((x0 - 0.28, ty), anchor: "east",
      text(5.5pt, fill: fg-light, str(tv)))
  }

  // X-axis tick marks + week labels.
  for tw in (0, 4, 8, 12) {
    let tx = sx(tw)
    line((tx, y0), (tx, y0 - 0.18),
      stroke: (thickness: 0.5pt, paint: fg))
    content((tx, y0 - 0.32), anchor: "north",
      text(5.5pt, fill: fg-light, str(tw)))
  }
  content((x0 + plot-w + 0.5, y0 - 0.32), anchor: "north",
    text(5.5pt, fill: fg-light, [week]))

  // Phase strip below the x-axis — evenly spaced like the mockup, with
  // arrows between phase names rather than tied to the (uneven) boundaries.
  content((6.5,  -1.4), text(6pt, fill: col-p3.darken(15%), [*manual*]))
  content((10.4, -1.4), text(6pt, fill: col-p3.darken(15%), sym.arrow))
  content((15.0, -1.4), text(6pt, fill: col-p3.darken(15%), [*basic skills*]))
  content((18.2, -1.4), text(6pt, fill: col-p3.darken(15%), sym.arrow))
  content((21.7, -1.4), text(6pt, fill: col-p3.darken(15%), [*full pipeline*]))

  // Title in upper-left, with a compact two-row legend underneath. The
  // curves are flat in the left third (week 0–8), so this region is empty.
  content((x0 + 0.3, y0 + plot-h + 0.3), anchor: "north-west",
    text(7pt, fill: col-p3.darken(15%), [*Growth over time*]))

  let lx = x0 + 0.4
  let ly = y0 + plot-h - 1.1
  let row-gap = 0.55
  // Problem types entry
  line((lx, ly), (lx + 0.55, ly),
    stroke: (thickness: 1.0pt, paint: col-p1.darken(5%)))
  circle((lx + 0.275, ly), radius: 0.11, fill: white,
    stroke: (thickness: 0.5pt, paint: col-p1.darken(5%)))
  content((lx + 0.7, ly), anchor: "west",
    text(5.2pt, fill: fg, [\# problem types]))
  // Reduction rules entry
  line((lx, ly - row-gap), (lx + 0.55, ly - row-gap),
    stroke: (thickness: 1.0pt, paint: col-red.darken(5%)))
  circle((lx + 0.275, ly - row-gap), radius: 0.11, fill: white,
    stroke: (thickness: 0.5pt, paint: col-red.darken(5%)))
  content((lx + 0.7, ly - row-gap), anchor: "west",
    text(5.2pt, fill: fg, [\# reduction rules]))
})

#let panel3(h: auto) = box(
  width: 9.5cm,
  height: h,
  stroke: panel-stroke,
  radius: panel-radius,
  fill: panel-fill(col-p3),
  inset: 10pt,
)[
  // Header
  #std.grid(
    columns: (0.9cm, 1fr),
    gutter: 6pt,
    align: (center + horizon, left + horizon),
    box(width: 0.8cm, height: 0.8cm,
      stroke: (thickness: 1.2pt, paint: col-p3),
      radius: 50%, fill: white,
      align(center + horizon, text(13pt, weight: "bold", fill: col-p3, [3]))),
    text(11pt, weight: "bold", fill: col-p3.darken(10%),
      [A reduction graph built at scale]),
  )

  #v(8pt)

  // Graph on the left, stats column on the right.
  #std.grid(
    columns: (1fr, 2.9cm),
    gutter: 8pt,
    align: (center + horizon, left + top),
    reduction-graph-real,
    std.grid(
      columns: 1,
      rows: (auto,) * 6,
      gutter: 4pt,
      stat-tile([190], [problem types], icon-label: [#sym.circle.filled.tiny]),
      stat-tile([265], [reduction rules], icon-label: [#sym.arrow.l.r]),
      stat-tile([129], [reducible to ILP], icon-label: [bar]),
      stat-tile([78], [reachable from 3-SAT], icon-label: [net]),
      stat-tile([~170k], [lines of Rust], icon-label: [`</>`]),
      stat-tile([~3], [months], icon-label: [#sym.circle.stroked.small]),
    ),
  )

  #v(45pt)

  // Growth curve panel
  #box(
    width: 100%,
    stroke: (thickness: 0.5pt, paint: luma(190)),
    radius: 4pt,
    fill: white,
    inset: 8pt,
  )[
    #align(center, growth-mini)
  ]
]

// ─────────────────────────────────────────────────────────────
// Assemble the three panels with connector arrows.
// ─────────────────────────────────────────────────────────────
// Chunky filled block arrow (PowerPoint-style) — bold visual weight for the
// top-level pipeline between the three independent panels.
#let big-arrow = align(horizon + center,
  canvas(length: 1pt, {
    import draw: *
    let col = rgb("#4a4a4a")
    let shaft = 14   // shaft length (pt)
    let head  = 9    // head length  (pt)
    let sh    = 4    // shaft half-thickness
    let hh    = 9    // head  half-thickness
    line(
      (0, sh), (shaft, sh),
      (shaft, hh), (shaft + head, 0), (shaft, -hh),
      (shaft, -sh), (0, -sh),
      close: true,
      fill: col, stroke: none,
    )
  }))

// Geometry constants for the overlay arrows.
#let p1w = 6.7cm
#let p2w = 7.2cm
#let panel-gap = 0.4cm        // visible gap between adjacent panels
#let arrow-half-w = 11.5pt    // half the big-arrow's geometric width
#let arrow-half-h = 9pt       // half its geometric height

// Panels keep a visible gap; the block arrows are placed *over* each seam so
// they straddle the gap and sit on top of both neighbouring panels.
#context {
  // Measure each panel at its natural height, then force all three to the
  // tallest so the row reads as a single horizontal band.
  let h = calc.max(
    measure(panel1()).height,
    measure(panel2()).height,
    measure(panel3()).height,
  )
  let panels-row = std.grid(
    columns: (auto, auto, auto),
    gutter: panel-gap,
    align: top,
    panel1(h: h), panel2(h: h), panel3(h: h),
  )
  // Seam centers (where each arrow sits horizontally).
  let seam1 = p1w + panel-gap / 2
  let seam2 = p1w + panel-gap + p2w + panel-gap / 2
  block({
    panels-row
    place(top + left, dx: seam1 - arrow-half-w,
      dy: h / 2 - arrow-half-h, big-arrow)
    place(top + left, dx: seam2 - arrow-half-w,
      dy: h / 2 - arrow-half-h, big-arrow)
  })
}
