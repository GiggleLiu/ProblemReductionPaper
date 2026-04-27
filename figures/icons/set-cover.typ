#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 1pt, fill: none)

#canvas({
  import draw: *

  circle((0, 0), radius: 1.4cm, fill: white, stroke: 2pt + rgb("#AAC4E9"))

  let blue   = rgb("#4e79a7")
  let green  = rgb("#59a14f")
  let orange = rgb("#f28e2b")

  // Three overlapping sets in a Venn-style triangular arrangement.
  // Light pastel fills + solid coloured outlines keep the boundaries
  // legible even when colours overlay.
  let r-set = 0.58
  let s-thick = 1.2pt
  let p-blue   = (-0.40,  0.22)
  let p-green  = ( 0.40,  0.22)
  let p-orange = ( 0.00, -0.45)

  circle(p-blue,   radius: r-set,
    fill: blue.lighten(82%),   stroke: s-thick + blue.darken(0%))
  circle(p-green,  radius: r-set,
    fill: green.lighten(82%),  stroke: s-thick + green.darken(0%))
  circle(p-orange, radius: r-set,
    fill: orange.lighten(78%), stroke: s-thick + orange.darken(0%))

  // Universe elements — small soft dots, placed so each sits in at
  // least one coloured set; some are in 2- or 3-set intersections.
  let dots = (
    (-0.78,  0.35),   // blue only
    (-0.30,  0.55),   // blue ∩ green
    ( 0.78,  0.35),   // green only
    (-0.40, -0.20),   // blue ∩ orange
    ( 0.00,  0.05),   // all three
    ( 0.40, -0.20),   // green ∩ orange
    (-0.20, -0.65),   // orange only
    ( 0.30, -0.70),   // orange only
  )
  for d in dots {
    circle(d, radius: 0.07,
      fill: white,
      stroke: 0.7pt + luma(80))
  }
})
