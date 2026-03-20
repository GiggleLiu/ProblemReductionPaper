#import "lib.typ": *

#set page(..fig-page)
#set text(..fig-text)

#canvas(length: 0.50cm, {
  import draw: *

  // ── Palette ──
  let col-bidi = rgb("#4e79a7")     // steel blue: bidirectional
  let col-edge-normal = black
  let r = 0.32

  // ── Node helper (uniform style) ──
  let node(pos, label, name-id, label-anchor: "center", label-pad: 0.12, highlight: false) = {
    let nfill = if highlight { fill-accent } else { fill-light }
    let nstroke = if highlight { (thickness: 1.0pt, paint: accent) } else { (thickness: 0.7pt, paint: border) }
    circle(pos, radius: r, fill: nfill, stroke: nstroke, name: name-id)
    if label-anchor == "center" {
      content(name-id, text(6pt, fill: fg, label))
    } else {
      let lp = if label-anchor == "south" { (rel: (0, -r - label-pad), to: name-id) } else if label-anchor == "north" { (rel: (0, r + label-pad), to: name-id) } else if label-anchor == "east" { (rel: (r + label-pad + 0.05, 0), to: name-id) } else { (rel: (-r - label-pad - 0.05, 0), to: name-id) }
      let la = if label-anchor == "south" { "north" } else if label-anchor == "north" { "south" } else if label-anchor == "east" { "west" } else { "east" }
      content(lp, anchor: la, text(6pt, fill: fg, label))
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
  node((4.8, 6.9), [3-SAT], "3sat", label-anchor: "north")
  node((8.1, 6.9), [], "gc", label-anchor: "north")

  // Middle row
  node((2.7, 4.6), [], "csat", label-anchor: "west")
  node((6.0, 4.6), [A], "sat")
  node((9.9, 4.6), [H], "mc")
  content((rel: (0, 0.7), to: "mc"), text(6pt)[NP-hard verified])

  // Lower row
  node((4.4, 2.3), [B], "mis")
  node((8.5, 2.3), [], "ising", label-anchor: "south")

  // Orphan
  node((11.5, 2.8), [$O$], "orphan")

  // Solvers
  node((4.0, 0.4), [S], "s-rydberg")
  content((rel: (0, -0.7), to: "s-rydberg"), text(6pt)[Hardware accelerated])
  node((6.5, 1.4), [C], "s-dwave")
  node((10.3, 0.4), [I], "s-ilp")
  content((rel: (0, -0.7), to: "s-ilp"), text(6pt)[Integer linear programming])

  // ── Normal edges ──
  edge("sat", "mis", name:"mis-sat")
  edge("sat", "s-dwave", name:"sat-dwave", dash: "dashed")
  content((rel: (0.7, 0), to: "sat-dwave.mid"), text(6pt)[Keep?])
  edge("sat", "ising")
  edge("gc", "sat")
  edge("csat", "mis")
  edge("mis", "s-rydberg")
  edge("ising", "s-dwave", name: "ising-dwave")

  content((rel: (0.3, 0), to: "mis-sat.mid"), [$f$])

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
  content((rel: (0.3, 0.2), to: "mis-dwave.mid"), [$g$])

  content((rel: (0.0, -0.6), to: "orphan"), anchor: "north",
    text(6pt)[orphan])
})
