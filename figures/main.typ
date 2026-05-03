#import "lib.typ": *
#import "@preview/pixel-family:0.2.0": bob, grace, crank, sentinel

#set page(width: auto, height: auto, margin: 6pt)
#set text(size: 8pt, font: "Helvetica")

// ── Panel-specific palette ──
#let col-p1   = rgb("#4e79a7")   // blue
#let col-p2   = rgb("#f28e2b")   // orange
#let col-p3   = rgb("#59a14f")   // green
#let col-red  = rgb("#e15759")
#let col-violet = rgb("#b07aa1")
#let col-teal = rgb("#76b7b2")
#let col-slate = rgb("#5a6878")  // neutral slate for solver-format boxes

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
  inset: 2pt,
  fill: white,
)[
  #std.grid(
    columns: (0.9cm, 1fr),
    gutter: 4pt,
    align: (center + horizon, left + horizon),
    if icon == none { icon-slot(w: 0.8cm, h: 0.7cm, label: [ ]) } else { icon },
    [
      #text(8.5pt, weight: "bold", fill: col.darken(10%), label) \
      #text(6pt, fill: fg-light, sub)
    ],
  )
]

// Section header inside a panel: thin divider + centered caption.
#let panel-section(label, col) = align(center)[
  #text(8.5pt, weight: "bold", fill: col.darken(10%), label)
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
  width: 6.5cm,
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
      align(center + horizon, text(13pt, weight: "bold", fill: col-p1, [(a)]))),
    text(11.5pt, weight: "bold", fill: col-p1.darken(10%),
      [Many hard problems,\ many solvers]),
  )

  #v(2pt)
  #panel-section([NP-hard problem types], col-p1)
  // #v(0pt)

  // 3 × 3 grid of problem tiles (last row has only "Bin Packing" and "…").
  #std.grid(
    columns: (1fr, 1fr, 1fr),
    rows: (auto, auto, auto),
    gutter: 6pt,
    problem-tile([3-SAT], icon: image("icons/3sat.svg", width: 1.5cm)),
    problem-tile([Max-Cut], icon: image("icons/max-cut.svg", width: 1.5cm)),
    problem-tile([Set Cover], icon: image("icons/set-cover.svg", width: 1.5cm)),
    problem-tile([3-Coloring], icon: image("icons/k-coloring.svg", width: 1.5cm)),
    problem-tile([TSP], icon: image("icons/tsp.svg", width: 1.5cm)),
    problem-tile([MIS], icon: image("icons/mis.svg", width: 1.5cm)),
    problem-tile([Bin Packing], icon: image("icons/bin-packing.svg", width: 1.5cm)),
    problem-tile([Partition], icon: image("icons/partition.svg", width: 1.5cm)),
    align(center + horizon, text(14pt, fill: fg-light, [$dots$])),
  )

  #v(6pt)
  #line(length: 100%, stroke: (thickness: 0.4pt, paint: luma(200), dash: "dashed"))
  // #v(3pt)
  #align(center, text(6.5pt, fill: fg-light,
    [Each backend takes its own format;\ problems must be encoded to fit.]))
  // #v(3pt)
  #line(length: 100%, stroke: (thickness: 0.4pt, paint: luma(200), dash: "dashed"))
  #panel-section([Solver formats / backends], col-slate)
  // #v(4pt)

  // 2×2 grid: (SAT, ILP) ; (Annealer, …).
  #std.grid(
    columns: (1fr, 1fr),
    rows: (auto, auto),
    gutter: 5pt,
    solver-box([SAT], [CNF formula], icon: image("icons/sat-solver.svg", width: 0.85cm), col: col-slate, w: 100%),
    solver-box([ILP], [$A x ≤ b, x in ZZ^n$], icon: image("icons/ilp-solver.svg", width: 0.85cm), col: col-slate, w: 100%),
    solver-box([Annealer], [QUBO / Ising], icon: image("icons/annealer.svg", width: 0.85cm), col: col-slate, w: 100%),
    align(center + horizon, text(14pt, fill: fg-light, [$dots$])),
  )

]

// ─────────────────────────────────────────────────────────────
// Panel 2: Harness-engineered agentic integration
// ─────────────────────────────────────────────────────────────

// Rounded card: title line, single-line body, accent bar on left.
#let agent-card(col, title, body, icon: none) = box(
  width: 100%,
  stroke: (thickness: 0.9pt, paint: col),
  radius: 5pt,
  fill: white,
  inset: (x: 6pt, y: 0.5pt),
)[
  #std.grid(
    columns: (0.85cm, 1fr),
    gutter: 5pt,
    align: (center + horizon, left + horizon),
    if icon == none { icon-slot(w: 0.7cm, h: 0.7cm, label: [bot]) } else { icon },
    [
      #text(8.5pt, weight: "bold", fill: col.darken(10%), title) \
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
        #text(8.5pt, weight: "bold", fill: fg,
          [[Rule] K-Coloring #sym.arrow ILP])
        // #h(3pt)
        // #text(8.5pt, fill: fg-light, [#024])
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
  width: 100%, height: 1.9cm,
  stroke: (thickness: 0.6pt, paint: col-violet),
  radius: 3pt,
  fill: white,
  inset: 3pt,
)[
  #align(center + top)[
    #if icon == none { icon-slot(w: 0.5cm, h: 0.5cm, label: [ ]) } else { icon }
    #v(3pt)
    #text(7pt, fill: col-violet.darken(20%), weight: "regular", align(center, label))
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
    text(9pt, weight: "bold", fill: col-violet.darken(15%),
      [Agents under harness (skill-based)]),
  )

  #v(6pt)

  // Implementation agent
  #agent-card(col-p1, [Implementation Agent],
    [Picks an issue, implements, submits a PR],
    icon: image("icons/agent-impl.svg", width: 1cm))

  #v(4pt)

  // Review agent
  #agent-card(col-p1, [Review Agent],
    [Reviews PR via parallel sub-agents],
    icon: image("icons/agent-review.svg", width: 1cm))

  #v(6pt)
  #line(length: 100%,
    stroke: (thickness: 0.4pt, paint: col-violet.lighten(40%), dash: "dashed"))
  #v(6pt)

  // 4 verification layers — base strip
  #std.grid(
    columns: (1fr, 1fr, 1fr, 1fr),
    gutter: 3pt,
    verif-cell([*compile-time checks*], icon: image("icons/type-check.svg", height: 0.75cm)),
    verif-cell([*automated unit tests*], icon: image("icons/unit-tests.svg", height: 0.75cm)),
    verif-cell([*round-trip verifications*], icon: image("icons/round-trip.svg", height: 0.75cm)),
    verif-cell([*agentic feature tests*], icon: image("icons/agent-user.svg", height: 0.75cm)),
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
      align(center + horizon, text(13pt, weight: "bold", fill: col-p2, [(b)]))),
    text(11.5pt, weight: "bold", fill: col-p2.darken(10%),
      [Harness-engineered\ agentic workflow]),
  )

  #v(15pt)

  // Person-at-laptop (left) and GitHub issue card (right).
  #std.grid(
    columns: (1.6cm, 1fr),
    gutter: 5pt,
    align: (center + horizon, left + horizon),
    [
      #image("icons/person-at-laptop.svg", width: 1.5cm)
      #v(3pt)
      #text(7pt, style: "normal", fill: col-p3.darken(10%),
        align(center, [*no-code\ contribution*]))
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
      image("icons/merged-validated.svg", width: 0.6cm),
      [
        #text(9pt, weight: "bold", fill: col-p3.darken(15%),
          [Validated Reduction Code]) \
        #text(6.3pt, fill: fg-light, [Human reviewed finally, merged into the codebase])
      ],
    )
  ]
]

// ─────────────────────────────────────────────────────────────
// Panel 3: A reduction graph built at scale
// ─────────────────────────────────────────────────────────────

// Small statistic tile for the right rail.
// Pass `icon:` for a real (canvas-drawn) icon; falls back to the dashed
// placeholder when only `icon-label` is given.
#let stat-tile(value, label, icon: none, icon-label: [ ]) = box(
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
    if icon == none {
      icon-slot(w: 0.6cm, h: 0.6cm, label: icon-label)
    } else {
      box(width: 0.7cm, height: 0.6cm, align(center + horizon, icon))
    },
    [
      #text(10.5pt, weight: "bold", fill: fg, value) \
      #text(6pt, fill: fg-light, label)
    ],
  )
]

// ── Icons for Panel 3 statistic tiles ────────────────────────────
// All icons share Panel 3's green palette and ~0.55cm visual size.
#let p3-stroke = col-p3.darken(8%)
#let p3-fill   = col-p3.lighten(82%)

// Icon: problem types — square, triangle, circle, hexagon in a 2×2 grid,
// evoking a catalog of distinct problem categories.
#let icon-problem-types = canvas(length: 0.55cm, {
  import draw: *
  let s = (paint: p3-stroke, thickness: 0.65pt, cap: "round", join: "round")
  let f = p3-fill
  let R = 0.135
  // top-left: rounded square
  rect((-0.22 - R, 0.22 - R), (-0.22 + R, 0.22 + R),
    radius: 0.025, stroke: s, fill: f)
  // top-right: equilateral triangle (centered on (tx, ty))
  let tx = 0.22
  let ty = 0.22
  let TR = R * 1.10
  line((tx,             ty + TR * 0.86),
       (tx - TR * 0.95, ty - TR * 0.55),
       (tx + TR * 0.95, ty - TR * 0.55),
       close: true, stroke: s, fill: f)
  // bottom-left: circle
  circle((-0.22, -0.22), radius: R, stroke: s, fill: f)
  // bottom-right: hexagon (flat-top)
  let hx = 0.22
  let hy = -0.22
  let hpts = ()
  for i in range(6) {
    let a = (i * 60) * 1deg
    hpts.push((hx + R * calc.cos(a), hy + R * calc.sin(a)))
  }
  line(..hpts, close: true, stroke: s, fill: f)
  hide(rect((-0.50, -0.50), (0.50, 0.50)))
})

// Icon: reduction rules — square (problem A) → circle (problem B).
// The two distinct shapes read as two different problem types; the arrow
// between them shows the reduction direction.
#let icon-reduction = canvas(length: 0.55cm, {
  import draw: *
  let s = (paint: p3-stroke, thickness: 0.75pt, cap: "round", join: "round")
  let f = p3-fill
  let R = 0.14
  let lcx = -0.34
  let rcx =  0.34
  // left node — square
  rect((lcx - R, -R), (lcx + R, R),
    radius: 0.035, stroke: s, fill: f)
  // right node — circle
  circle((rcx, 0), radius: R, stroke: s, fill: f)
  // arrow between (longer shaft so the line is clearly visible)
  line((lcx + R + 0.025, 0), (rcx - R - 0.025, 0),
    stroke: (paint: p3-stroke, thickness: 0.9pt, cap: "round"),
    mark: (end: "straight", scale: 0.35, fill: p3-stroke))
  hide(rect((-0.50, -0.50), (0.50, 0.50)))
})

// Icon: reducible to ILP — three differently-shaped source problems
// (△, ○, □) on the left, each with an arrow converging into a single ILP
// target node on the right (marked with a "≤" glyph for the inequality
// system Ax ≤ b).
#let icon-ilp = canvas(length: 0.55cm, {
  import draw: *
  let s     = (paint: p3-stroke, thickness: 0.65pt, cap: "round", join: "round")
  let s-arr = (paint: p3-stroke, thickness: 0.55pt, cap: "round")
  let f = p3-fill
  let r = 0.095

  // ── Three sources on the left ──
  let sx = -0.36
  let ys = (0.30, 0.00, -0.30)

  // top: triangle
  let ty = ys.at(0)
  line((sx,           ty + r * 1.05),
       (sx - r * 0.95, ty - r * 0.55),
       (sx + r * 0.95, ty - r * 0.55),
       close: true, stroke: s, fill: f)
  // mid: circle
  circle((sx, ys.at(1)), radius: r, stroke: s, fill: f)
  // bottom: square
  let qy = ys.at(2)
  rect((sx - r, qy - r), (sx + r, qy + r),
    radius: 0.022, stroke: s, fill: f)

  // ── ILP target on the right ──
  let tcx = 0.30
  let tcy = 0.00
  let tR  = 0.17
  rect((tcx - tR, tcy - tR), (tcx + tR, tcy + tR),
    radius: 0.04,
    stroke: (paint: p3-stroke, thickness: 0.85pt),
    fill:  col-p3.lighten(60%))
  // small "≤" glyph inside (two short horizontals, lower one nudged left)
  let lx = tcx - 0.07
  let ly = tcy
  line((lx,        ly + 0.045), (lx + 0.10, ly + 0.045),
    stroke: (paint: p3-stroke.darken(15%), thickness: 0.75pt, cap: "round"))
  line((lx - 0.01, ly - 0.045), (lx + 0.09, ly - 0.045),
    stroke: (paint: p3-stroke.darken(15%), thickness: 0.75pt, cap: "round"))

  // ── Converging arrows: each source → target ──
  for y in ys {
    // start: just outside the source's right edge
    let x0 = sx + r + 0.025
    let y0 = y
    // end: just outside the target's left edge, on the line toward (x0, y0)
    let x1-edge = tcx - tR - 0.015
    // angle from source to target centre, then place tip on the box's left edge
    let dx = tcx - x0
    let dy = tcy - y0
    let len = calc.sqrt(dx * dx + dy * dy)
    let ux = dx / len
    let uy = dy / len
    // tip lands on the left edge of the target
    let t-len = (x1-edge - x0) / ux
    let x1 = x0 + ux * t-len
    let y1 = y0 + uy * t-len
    line((x0, y0), (x1, y1),
      stroke: s-arr,
      mark: (end: "straight", scale: 0.30, fill: p3-stroke))
  }

  hide(rect((-0.50, -0.50), (0.50, 0.50)))
})

// Icon: reachable from 3-SAT — mirror of `icon-ilp`. A 3-SAT source node
// on the left (rounded square marked with "•••" for the three literals
// of a clause) fans out via three arrows to △, ○, □ targets on the
// right.
#let icon-reach = canvas(length: 0.55cm, {
  import draw: *
  let s     = (paint: p3-stroke, thickness: 0.65pt, cap: "round", join: "round")
  let s-arr = (paint: p3-stroke, thickness: 0.55pt, cap: "round")
  let f = p3-fill
  let r = 0.095

  // ── 3-SAT source on the left ──
  let scx = -0.30
  let scy = 0.00
  let sR  = 0.17
  rect((scx - sR, scy - sR), (scx + sR, scy + sR),
    radius: 0.04,
    stroke: (paint: p3-stroke, thickness: 0.85pt),
    fill: col-p3.lighten(60%))
  // Three stacked literal-bars inside (mirror of `≤`'s two bars in icon-ilp).
  let bx = scx - 0.07
  let bx2 = scx + 0.07
  let bs = (paint: p3-stroke.darken(15%), thickness: 0.75pt, cap: "round")
  line((bx, scy + 0.075), (bx2, scy + 0.075), stroke: bs)
  line((bx, scy        ), (bx2, scy        ), stroke: bs)
  line((bx, scy - 0.075), (bx2, scy - 0.075), stroke: bs)

  // ── Three targets on the right ──
  let tx = 0.36
  let ys = (0.30, 0.00, -0.30)

  // top: triangle
  let ty = ys.at(0)
  line((tx,            ty + r * 1.05),
       (tx - r * 0.95, ty - r * 0.55),
       (tx + r * 0.95, ty - r * 0.55),
       close: true, stroke: s, fill: f)
  // mid: circle
  circle((tx, ys.at(1)), radius: r, stroke: s, fill: f)
  // bottom: square
  let qy = ys.at(2)
  rect((tx - r, qy - r), (tx + r, qy + r),
    radius: 0.022, stroke: s, fill: f)

  // ── Diverging arrows: source → each target ──
  for y in ys {
    // start: source's right edge on the line toward (tx, y)
    let dx = tx - scx
    let dy = y - scy
    let len = calc.sqrt(dx * dx + dy * dy)
    let ux = dx / len
    let uy = dy / len
    let x0-edge = scx + sR + 0.015
    let t0-len = (x0-edge - scx) / ux
    let x0 = scx + ux * t0-len
    let y0 = scy + uy * t0-len
    // end: just outside target shape
    let x1 = tx - ux * (r + 0.025)
    let y1 = y  - uy * (r + 0.025)
    line((x0, y0), (x1, y1),
      stroke: s-arr,
      mark: (end: "straight", scale: 0.30, fill: p3-stroke))
  }

  hide(rect((-0.50, -0.50), (0.50, 0.50)))
})

// Icon: lines of Rust — official Rust gear-and-R logo, recoloured to the
// panel-3 green palette so it sits with the other stat-tile icons.
#let icon-code = image("icons/Rust.svg", width: 0.55cm, height: 0.55cm)

// Icon: variants — three same-shape rounded squares stacked diagonally
// with progressive fill, reading as "multiple variants of the same
// underlying problem type" (contrasts with icon-problem-types, which
// shows four different shapes).
#let icon-variants = canvas(length: 0.55cm, {
  import draw: *
  let s = (paint: p3-stroke, thickness: 0.65pt, cap: "round", join: "round")
  let sw = 0.36
  let sh = 0.36
  let off = 0.09
  // Back card (lightest)
  rect((-off - sw / 2, -off - sh / 2), (-off + sw / 2, -off + sh / 2),
    radius: 0.045, stroke: s, fill: col-p3.lighten(80%))
  // Mid card
  rect((-sw / 2 + 0.0, -sh / 2 + 0.0), ( sw / 2,  sh / 2),
    radius: 0.045, stroke: s, fill: col-p3.lighten(60%))
  // Front card (darkest, on top)
  rect(( off - sw / 2,  off - sh / 2), ( off + sw / 2,  off + sh / 2),
    radius: 0.045, stroke: s, fill: col-p3.lighten(35%))
  hide(rect((-0.50, -0.50), (0.50, 0.50)))
})

// Real reduction graph: 155 problem types + 241 reduction edges from
// data/reduction-graph-layout.json (built by Graphviz `sfdp` with prism
// overlap-removal in scripts/build-reduction-graph-layout.py). Only the
// two hubs — 3-SAT and ILP — carry text labels.
#let reduction-graph-real = {
  let data = json("../data/reduction-graph-layout.json")
  let hubs = ("KSatisfiability", "ILP")

  let col-node = col-p3   // uniform color for every non-hub problem
  let hub-color(name) = if name == "KSatisfiability" { col-p1 } else { col-violet }

  let plot-w = 8.6
  let plot-h = 16.0
  let r-node = 0.20
  let r-hub  = 0.60       // hub radius — large enough to hold a label inside
  let edge-stroke = (thickness: 0.22pt, paint: rgb(120, 120, 130, 130))
  let edge-curve = 0.18

  // Use full data bounds so each node lands at its true sfdp position;
  // earlier we percentile-clipped + clamped, but that collapsed all
  // outliers to the same edge coordinate (causing overlapping dots).
  let xs = data.nodes.map(n => n.x)
  let ys = data.nodes.map(n => n.y)
  let x-min = calc.min(..xs)
  let x-max = calc.max(..xs)
  let y-min = calc.min(..ys)
  let y-max = calc.max(..ys)
  let pad = 0.02
  let nx-pos(x) = {
    let t = (x - x-min) / (x-max - x-min)
    pad * plot-w + t * (1 - 2 * pad) * plot-w
  }
  let ny-pos(y) = {
    let t = (y - y-min) / (y-max - y-min)
    pad * plot-h + t * (1 - 2 * pad) * plot-h
  }

  let name-to-pos = (:)
  for n in data.nodes {
    name-to-pos.insert(n.name, (nx-pos(n.x), ny-pos(n.y)))
  }
  let is-hub(name) = name in hubs

  canvas(length: 0.5cm, {
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

    // Ordinary nodes — uniform color
    for n in data.nodes {
      if is-hub(n.name) { continue }
      circle(
        name-to-pos.at(n.name),
        radius: r-node,
        fill: col-node.lighten(60%),
        stroke: (thickness: 0.25pt, paint: col-node.darken(5%)),
      )
    }

    // Hubs — bigger filled disk with label INSIDE.
    for n in data.nodes {
      if not is-hub(n.name) { continue }
      let col = hub-color(n.name)
      let label = if n.name == "KSatisfiability" { [3-SAT] } else { [ILP] }
      let (cx, cy) = name-to-pos.at(n.name)
      circle(
        (cx, cy),
        radius: r-hub,
        fill: col.darken(5%),
        stroke: (thickness: 0.5pt, paint: col.darken(25%)),
      )
      content(
        (cx, cy),
        anchor: "center",
        text(6pt, weight: "bold", fill: white, label),
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
  let plot-w = 21.0
  let plot-h = 6.4
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
  // Positions are proportional to plot-w so the strip stays within the
  // plot bounds when the chart is resized.
  content((plot-w * 0.250, -1.4), text(6pt, fill: col-p3.darken(15%), [*manual*]))
  content((plot-w * 0.400, -1.4), text(6pt, fill: col-p3.darken(15%), sym.arrow))
  content((plot-w * 0.557, -1.4), text(6pt, fill: col-p3.darken(15%), [*basic skills*]))
  content((plot-w * 0.700, -1.4), text(6pt, fill: col-p3.darken(15%), sym.arrow))
  content((plot-w * 0.835, -1.4), text(6pt, fill: col-p3.darken(15%), [*full pipeline*]))

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
  width: 8.3cm,
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
      align(center + horizon, text(13pt, weight: "bold", fill: col-p3, [(c)]))),
    text(11.5pt, weight: "bold", fill: col-p3.darken(10%),
      [A reduction graph built at scale]),
  )

  #v(-3pt)

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
      stat-tile([190], [problem types],          icon: icon-problem-types),
      stat-tile([220], [concrete type of problems(variants)], icon: icon-variants),
      stat-tile([265], [reduction rules],        icon: icon-reduction),
      stat-tile([129], [reducible to ILP],       icon: icon-ilp),
      stat-tile([78],  [reachable from\ 3-SAT],   icon: icon-reach),
      stat-tile([\~170k], [lines of Rust code],  icon: icon-code),
    ),
  )

  #v(2pt)

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
#let p1w = 6.5cm
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
