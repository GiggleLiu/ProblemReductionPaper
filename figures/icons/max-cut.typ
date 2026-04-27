#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 1pt, fill: none)

#canvas({
  import draw: *

  circle((0, 0), radius: 1.4cm, fill: white, stroke: 2pt + rgb("#AAC4E9"))

  let red    = rgb("#e42f29")
  let blue   = rgb("#4e79a7")
  let cut-col = rgb("#f28e2b")

  let intra-stroke = (paint: luma(180), thickness: 0.6pt, dash: "dotted")
  let cut-stroke   = (paint: cut-col.darken(5%), thickness: 1.5pt, cap: "round")

  // Two clusters of vertices. Position separation makes the partition
  // self-evident; no explicit dividing line needed.
  let r1 = (-0.55,  0.65)
  let r2 = (-0.90,  0.05)
  let r3 = (-0.45, -0.55)
  let b1 = ( 0.50,  0.70)
  let b2 = ( 0.85,  0.00)
  let b3 = ( 0.55, -0.55)

  // Intra-cluster edges — faint dotted, *not* part of the cut.
  line(r1, r2, stroke: intra-stroke)
  line(r2, r3, stroke: intra-stroke)
  line(b1, b2, stroke: intra-stroke)
  line(b2, b3, stroke: intra-stroke)

  // Cut edges — bold orange. These are what Max-Cut maximises.
  line(r1, b1, stroke: cut-stroke)
  line(r1, b2, stroke: cut-stroke)
  line(r2, b2, stroke: cut-stroke)
  line(r3, b3, stroke: cut-stroke)
  line(r3, b2, stroke: cut-stroke)

  // Vertices (drawn on top so edges meet the rim cleanly).
  for p in (r1, r2, r3) {
    circle(p, radius: 0.14, fill: red,  stroke: 0.6pt + red.darken(25%))
  }
  for p in (b1, b2, b3) {
    circle(p, radius: 0.14, fill: blue, stroke: 0.6pt + blue.darken(25%))
  }
})
