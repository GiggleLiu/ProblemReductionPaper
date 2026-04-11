#import "lib.typ": *

#set page(..fig-page)
#set text(..fig-text)

#canvas(length: 0.50cm, {
  import draw: *

  // ── Palette ──
  let col-edge-normal = black
  let r = 0.50

  // ── Node helper (uniform style) ──
  let node(pos, label, name-id, label-anchor: "center", label-pad: 0.15, highlight: false) = {
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

  // ── Layout ──
  // Top row
  node((3.5, 5.4), [3-SAT], "3sat", label-anchor: "north", highlight: true)
  node((6.5, 5.4), [], "gc", label-anchor: "north")

  // Middle row
  node((1.2, 3.5), [], "csat", label-anchor: "west")
  node((4.5, 3.5), [$A$], "sat")
  node((8.0, 3.5), [$H$], "mc")
  content((rel: (0, 0.9), to: "mc"), text(7pt)[NP-hard verified])

  // Lower row
  node((3.0, 1.6), [$B$], "mis")
  node((6.8, 1.6), [], "ising", label-anchor: "south")

  // Solvers (spread wider, lower)
  node((1.5, -0.4), [$S$], "s-rydberg")
  content((rel: (0.9, 0), to: "s-rydberg"), text(7pt)[$t_(S)$])

  node((5.0, 0.4), [$C$], "s-dwave")

  node((9.0, -0.4), [$I$], "s-ilp", highlight: true)
  content((rel: (0.9, 0), to: "s-ilp"), text(7pt)[$t_(I)$])
  content((rel: (-1.5, -1), to: "s-ilp"), text(7pt)[Integer linear programming])

  // ── Edges ──
  edge("sat", "mis", name: "sat-mis")
  edge("sat", "s-dwave", name: "sat-dwave", dash: "dashed")
  edge("sat", "ising")
  edge("gc", "sat")
  edge("csat", "mis")
  edge("mis", "s-rydberg")
  edge("ising", "s-dwave", name: "ising-dwave")

  content((rel: (-1, 0.3), to: "sat-mis.mid"), [$r_(B arrow.l A)$])

  // ── Bidirectional: Max-Cut ↔ Ising ──
  bezier("mc.south", "ising.east", (rel: (0.0, -1.3), to: "mc"),
    stroke: (thickness: lw), mark: mk, shorten: (start: gap, end: gap))
  bezier("ising.north", "mc.west", (rel: (0.0, 1.3), to: "ising"),
    stroke: (thickness: lw), mark: mk, shorten: (start: gap, end: gap))

  // 3-SAT → SAT
  edge("3sat", "sat")

  // CircuitSAT → SAT
  edge("csat", "sat")

  // Ising → ILP
  edge("ising", "s-ilp")

  // MIS → D-Wave
  edge("mis", "s-dwave", name: "mis-dwave")
  content((rel: (0.2, 0.5), to: "mis-dwave.mid"), [$r_(C arrow.l B)$])
})
