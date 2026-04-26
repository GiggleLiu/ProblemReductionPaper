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
#let panel1 = box(
  width: 6.7cm,
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

#let panel2 = box(
  width: 7.2cm,
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

  #v(8pt)

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

// Reduction graph sketch. Not the final 190-node graph — a stylized stand-in
// with ILP as a large central hub and 3-SAT highlighted on the upper-left.
#let reduction-graph-sketch = canvas(length: 0.32cm, {
  import draw: *

  let palette = (
    col-p1, col-p3, col-red, col-violet, col-teal,
    rgb("#edc949"), rgb("#ff9da7"), rgb("#9c755f"),
  )
  // Deterministic pseudo-random using a small LCG.
  let seed = 17
  let rand(state) = {
    let s = calc.rem(state * 1103515245 + 12345, 2147483648)
    (s, s / 2147483648)
  }

  // Hub positions.
  let sat-x = 1.5
  let sat-y = 11.5
  let sat-r = 0.95
  let ilp-x = 9.5
  let ilp-y = 6.0
  let ilp-r = 1.5

  // Generated small nodes on a jittered grid, skipping the hub zones.
  let smalls = ()
  let state = seed
  let rows = 7
  let cols = 7
  let x0 = 1.3
  let y0 = 1.3
  let dx = 2.35
  let dy = 1.9
  for r in range(rows) {
    for c in range(cols) {
      let (s1, jx) = rand(state)
      state = s1
      let (s2, jy) = rand(state)
      state = s2
      let (s3, jc) = rand(state)
      state = s3
      let x = x0 + c * dx + (jx - 0.5) * 1.0
      let y = y0 + r * dy + (jy - 0.5) * 0.9
      // Skip points inside either hub zone (with buffer).
      let near-ilp = calc.pow(x - ilp-x, 2) + calc.pow(y - ilp-y, 2) < 6.5
      let near-sat = calc.pow(x - sat-x, 2) + calc.pow(y - sat-y, 2) < 3.2
      if not near-ilp and not near-sat {
        let cidx = calc.rem(int(jc * 1000), palette.len())
        smalls.push((x, y, 0.38, cidx))
      }
    }
  }

  // Build edge list: connect each small node to its 2 nearest neighbors.
  let dist2(a, b) = {
    let ax = a.at(0)
    let ay = a.at(1)
    let bx = b.at(0)
    let by = b.at(1)
    (ax - bx) * (ax - bx) + (ay - by) * (ay - by)
  }

  // Merge hub points for neighbor search.
  let all = smalls
  all.push((sat-x, sat-y, sat-r, 0))   // sat
  all.push((ilp-x, ilp-y, ilp-r, 5))   // ilp

  // Draw edges (behind nodes).
  for (i, p) in smalls.enumerate() {
    // Find 2 closest peers in `all` (excluding self).
    let best1 = -1
    let d1 = 1e9
    let best2 = -1
    let d2 = 1e9
    for (j, q) in all.enumerate() {
      if j == i { continue }
      let d = dist2(p, q)
      if d < d1 {
        d2 = d1
        best2 = best1
        d1 = d
        best1 = j
      } else if d < d2 {
        d2 = d
        best2 = j
      }
    }
    for b in (best1, best2) {
      if b < 0 { continue }
      let q = all.at(b)
      let px = p.at(0)
      let py = p.at(1)
      let qx = q.at(0)
      let qy = q.at(1)
      let len = calc.sqrt((qx - px) * (qx - px) + (qy - py) * (qy - py))
      if len < 0.01 { continue }
      let ux = (qx - px) / len
      let uy = (qy - py) / len
      let pr = p.at(2)
      let qr = q.at(2)
      line(
        (px + ux * pr, py + uy * pr),
        (qx - ux * qr, qy - uy * qr),
        stroke: (thickness: 0.35pt, paint: luma(120)),
        mark: (end: "straight", scale: 0.18),
      )
    }
  }

  // Draw small nodes on top.
  for p in smalls {
    let (x, y, r, cidx) = p
    let col = palette.at(cidx)
    circle((x, y), radius: r,
      fill: col.lighten(85%),
      stroke: (thickness: 0.5pt, paint: col.darken(5%)))
  }

  // Hubs — larger, labeled.
  circle((sat-x, sat-y), radius: sat-r,
    fill: col-p1.lighten(80%),
    stroke: (thickness: 1.1pt, paint: col-p1),
    name: "sat")
  content("sat", text(7pt, weight: "bold", fill: col-p1.darken(20%), [3-SAT]))

  circle((ilp-x, ilp-y), radius: ilp-r,
    fill: rgb("#edc949").lighten(60%),
    stroke: (thickness: 1.2pt, paint: rgb("#edc949").darken(20%)),
    name: "ilp")
  content("ilp", text(9pt, weight: "bold", fill: fg, [ILP]))
})

// Mini growth-over-time curve (Phase 1 → Phase 2 → Phase 3, schematic).
#let growth-mini = canvas(length: 0.3cm, {
  import draw: *

  // Axes
  let x0 = 0.0
  let y0 = 0.0
  let w = 18.0
  let h = 5.5
  line((x0, y0), (x0 + w, y0),
    stroke: (thickness: 0.6pt, paint: fg),
    mark: (end: "straight", scale: 0.3))
  line((x0, y0), (x0, y0 + h),
    stroke: (thickness: 0.6pt, paint: fg))

  // Data points (schematic: shallow then steep).
  let pts = (
    (1.0, 0.4), (3.0, 0.6), (5.0, 0.9),
    (7.0, 1.4), (9.0, 1.8), (11.0, 2.4),
    (13.0, 3.5), (15.0, 4.8), (16.5, 5.1),
  )

  // Fill under curve.
  let fill-pts = pts + ((16.5, 0.0), (1.0, 0.0))
  merge-path(close: true, fill: col-p3.lighten(80%), stroke: none, {
    line(..fill-pts)
  })

  // Curve
  line(..pts,
    stroke: (thickness: 1.4pt, paint: col-p3.darken(5%)))

  // Markers
  for p in pts {
    circle(p, radius: 0.2, fill: white, stroke: (thickness: 0.8pt, paint: col-p3.darken(5%)))
  }

  // Phase boundaries (vertical dashed)
  line((6.0, 0), (6.0, h),
    stroke: (thickness: 0.4pt, paint: luma(170), dash: "dashed"))
  line((12.0, 0), (12.0, h),
    stroke: (thickness: 0.4pt, paint: luma(170), dash: "dashed"))

  // Labels under x-axis
  content((3.0, -0.9), text(6pt, fill: fg, [manual]))
  content((6.0, -0.9), text(6pt, fill: fg-light, sym.arrow))
  content((9.0, -0.9), text(6pt, fill: fg, [basic skills]))
  content((12.0, -0.9), text(6pt, fill: fg-light, sym.arrow))
  content((15.0, -0.9), text(6pt, fill: fg, [full pipeline]))

  // Title, upper-left
  content((x0 + 0.3, y0 + h - 0.3), anchor: "north-west",
    text(7pt, fill: col-p3.darken(15%), [Growth over time]))
})

#let panel3 = box(
  width: 10.8cm,
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
    reduction-graph-sketch,
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

  #v(10pt)

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

// Panel widths (kept here so the overlay arrows know where the seams sit).
#let p1w = 6.7cm
#let p2w = 7.2cm
#let arrow-half-w = 11.5pt   // half the big-arrow's geometric width
#let arrow-half-h = 9pt      // half its geometric height

// Panels sit edge-to-edge; the block arrows overlay each seam, sitting on top
// of both adjacent panels rather than separating them. We measure the panel
// row's actual height to vertically center the arrows.
#context {
  let panels-row = std.grid(
    columns: (auto, auto, auto),
    gutter: 0pt,
    align: top,
    panel1, panel2, panel3,
  )
  let h = measure(panels-row).height
  block({
    panels-row
    place(top + left, dx: p1w - arrow-half-w,
      dy: h / 2 - arrow-half-h, big-arrow)
    place(top + left, dx: p1w + p2w - arrow-half-w,
      dy: h / 2 - arrow-half-h, big-arrow)
  })
}
