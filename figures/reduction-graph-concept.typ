#import "lib.typ": *

#set page(..fig-page)
#set text(..fig-text)

#canvas(length: 0.50cm, {
  import draw: *

  // ── Palette ──
  let col-bidi = rgb("#4e79a7")     // steel blue: bidirectional
  let col-edge-normal = black
  let r = 0.50

  // ── Node helper (uniform style) ──
  let node(pos, label, name-id, label-anchor: "center", label-pad: 0.12, highlight: false) = {
    let nfill = if highlight { fill-accent } else { fill-light }
    let nstroke = if highlight { (thickness: 1.0pt, paint: accent) } else { (thickness: 0.7pt, paint: border) }
    circle(pos, radius: r, fill: nfill, stroke: nstroke, name: name-id)
    if label-anchor == "center" {
      content(name-id, text(7pt, fill: fg, label))
    } else {
      let lp = if label-anchor == "south" { (rel: (0, -r - label-pad), to: name-id) } else if label-anchor == "north" { (rel: (0, r + label-pad), to: name-id) } else if label-anchor == "east" { (rel: (r + label-pad + 0.05, 0), to: name-id) } else { (rel: (-r - label-pad - 0.05, 0), to: name-id) }
      let la = if label-anchor == "south" { "north" } else if label-anchor == "north" { "south" } else if label-anchor == "east" { "west" } else { "east" }
      content(lp, anchor: la, text(7pt, fill: fg, label))
    }
  }

  // ── Edge helpers ──
  let lw = 0.8pt
  let mk = (end: "straight", scale: 0.32)
  let gap = 0.08

  let edge(from, to, name: none, dash: none) = {
    line(from, to, stroke: (thickness: lw, paint: col-edge-normal, dash: dash), mark: mk, shorten: (start: gap, end: gap), name: name)
  }

  let path-edge(from, to, col) = {
    line(from, to, stroke: (thickness: lw, paint: col), mark: mk, shorten: (start: gap, end: gap))
  }

  // ── Layout ──
  // Top row
  node((3.2, 5.4), [3-SAT], "3sat", label-anchor: "north", highlight: true)
  node((5.8, 5.4), [], "gc", label-anchor: "north")

  // Middle row
  node((1.5, 3.6), [], "csat", label-anchor: "west")
  node((4.2, 3.6), [$A$], "sat")
  node((7.2, 3.6), [$H$], "mc")
  content((rel: (0, 0.85), to: "mc"), text(7pt)[NP-hard verified])

  // Lower row
  node((3.0, 1.8), [$B$], "mis")
  node((6.2, 1.8), [], "ising", label-anchor: "south")

  // Orphan
  node((8.5, 2.2), [$O$], "orphan")

  // Solvers
  node((2.6, 0.2), [$S$], "s-rydberg")
  content((rel: (0, -0.85), to: "s-rydberg"), text(7pt)[Hardware accelerated])
  content((rel: (0.85, 0), to: "s-rydberg"), text(7pt)[$t_(S)$])
  node((4.8, 1.0), [$C$], "s-dwave")
  node((7.6, 0.2), [$I$], "s-ilp", highlight: true)
  content((rel: (0.85, 0), to: "s-ilp"), text(7pt)[$t_(I)$])
  content((rel: (0, -0.85), to: "s-ilp"), text(7pt)[Integer linear programming])

  // ── Normal edges ──
  edge("sat", "mis", name:"mis-sat")
  edge("sat", "s-dwave", name:"sat-dwave", dash: "dashed")
  edge("sat", "ising")
  edge("gc", "sat")
  edge("csat", "mis")
  edge("mis", "s-rydberg")
  edge("ising", "s-dwave", name: "ising-dwave")

  content((rel: (-0.6, 0.3), to: "mis-sat.mid"), [$r_(A arrow.r B)$])

  // ── Bidirectional reductions (two curved bezier arrows) ──
  // Max-Cut ↔ Ising
  bezier("mc.south", "ising.east", (rel: (-0.0, -1.5), to: "mc"),
    stroke: (thickness: lw), mark: mk, shorten: (start: gap, end: gap))
  bezier("ising.north", "mc.west", (rel: (0.0, 1.5), to: "ising"),
    stroke: (thickness: lw), mark: mk, shorten: (start: gap, end: gap))

  // ── Proof path (purple): 3-SAT → SAT ──
  edge("3sat", "sat")

  // ── Reduction path 1 (red): Factoring → Circuit SAT → SAT → ILP ──
  edge("csat", "sat")
  edge("ising", "s-ilp")

  // ── Reduction path 2 (green): Graph Col. → SAT → MIS → QUBO ──
  edge("gc", "sat")
  edge("sat", "mis")
  edge("mis", "s-dwave", name: "mis-dwave")
  content((rel: (0.25, 0.4), to: "mis-dwave.mid"), [$r_(B arrow.r C)$])

  content((rel: (0.0, -0.6), to: "orphan"), anchor: "north",
    text(6pt)[orphan])
})
