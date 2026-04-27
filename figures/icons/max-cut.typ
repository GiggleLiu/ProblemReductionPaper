#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 1pt, fill: none)

#canvas({
  import draw: *

  circle((0, 0), radius: 1.4cm, fill: white, stroke: 2pt + rgb("#AAC4E9"))

  let red  = rgb("#e42f29")
  let blue = rgb("#4e79a7")
  let edge-col = black.lighten(20%)

  let intra-stroke = (paint: edge-col, thickness: 0.9pt, cap: "round")
  let cut-stroke   = (paint: edge-col, thickness: 0.9pt, cap: "round",
                      dash: "densely-dashed")

  // Two clusters of vertices.
  let r1 = (-0.55,  0.65)
  let r2 = (-0.90,  0.05)
  let r3 = (-0.45, -0.55)
  let b1 = ( 0.50,  0.70)
  let b2 = ( 0.85,  0.00)
  let b3 = ( 0.55, -0.55)

  // Intra-cluster edges — solid.
  line(r1, r2, stroke: intra-stroke)
  line(r2, r3, stroke: intra-stroke)
  line(b1, b2, stroke: intra-stroke)
  line(b2, b3, stroke: intra-stroke)

  // Cut edges — dashed (these are what Max-Cut maximises).
  line(r1, b1, stroke: cut-stroke)
  line(r1, b2, stroke: cut-stroke)
  line(r2, b2, stroke: cut-stroke)
  line(r3, b3, stroke: cut-stroke)
  line(r3, b2, stroke: cut-stroke)

  for p in (r1, r2, r3) {
    circle(p, radius: 0.14, fill: red,  stroke: 0.6pt + red.darken(25%))
  }
  for p in (b1, b2, b3) {
    circle(p, radius: 0.14, fill: blue, stroke: 0.6pt + blue.darken(25%))
  }
})
