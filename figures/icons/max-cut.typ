#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 1pt, fill: none)

#canvas({
  import draw: *

  circle((0, 0), radius: 1.4cm, fill: white, stroke: 2pt + rgb("#AAC4E9"))

  let blue       = rgb("#4e79a7")
  let blue-light = blue.lighten(45%)
  let edge-stroke = (paint: black.lighten(20%), thickness: 0.9pt, cap: "round")
  let cut-curve-stroke = (paint: luma(80),
                          thickness: 1.1pt, cap: "round",
                          dash: "densely-dashed")

  // Two clusters of vertices.
  let r1 = (-0.55,  0.65)
  let r2 = (-0.90,  0.05)
  let r3 = (-0.45, -0.55)
  let b1 = ( 0.50,  0.70)
  let b2 = ( 0.85,  0.00)
  let b3 = ( 0.55, -0.55)

  // All graph edges share the same solid stroke. The "cut" is the dashed
  // curve drawn on top — edges that the curve crosses are cut edges.
  line(r1, r2, stroke: edge-stroke)
  line(r2, r3, stroke: edge-stroke)
  line(b1, b2, stroke: edge-stroke)
  line(b2, b3, stroke: edge-stroke)
  line(r1, b1, stroke: edge-stroke)
  line(r1, b2, stroke: edge-stroke)
  line(r2, b2, stroke: edge-stroke)
  line(r3, b3, stroke: edge-stroke)
  line(r3, b2, stroke: edge-stroke)

  // Vertices.
  for p in (r1, r2, r3) {
    circle(p, radius: 0.14, fill: blue,       stroke: 0.6pt + blue.darken(25%))
  }
  for p in (b1, b2, b3) {
    circle(p, radius: 0.14, fill: blue-light, stroke: 0.6pt + blue.darken(15%))
  }

  // Cut curve — a smooth dashed wave running top-to-bottom through the
  // gap between the two clusters; the edges it crosses are the cut.
  hobby(
    ( 0.05,  1.10),
    (-0.12,  0.55),
    ( 0.18,  0.05),
    (-0.05, -0.45),
    ( 0.10, -1.10),
    stroke: cut-curve-stroke,
  )
})
