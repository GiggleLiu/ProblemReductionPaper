#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 1pt, fill: none)

#canvas({
  import draw: *

  circle((0, 0), radius: 1.4cm, fill: white, stroke: 2pt + rgb("#AAC4E9"))

  let blue = rgb("#4e79a7")

  // Three overlapping sets in a Venn-style triangular arrangement.
  // Single blue hue at three different shades distinguishes the sets
  // without introducing a second colour.
  let r-set = 0.58
  let s-thick = 1.2pt
  let p-1 = (-0.40,  0.22)
  let p-2 = ( 0.40,  0.22)
  let p-3 = ( 0.00, -0.45)

  // Pass 1: fills only.
  circle(p-1, radius: r-set, fill: blue.lighten(80%), stroke: none)
  circle(p-2, radius: r-set, fill: blue.lighten(80%), stroke: none)
  circle(p-3, radius: r-set, fill: blue.lighten(80%), stroke: none)

  // Pass 2: strokes only — drawn on top so all three rims stay intact.
  circle(p-1, radius: r-set, fill: none, stroke: s-thick + blue.darken(35%))
  circle(p-2, radius: r-set, fill: none, stroke: s-thick + blue)
  circle(p-3, radius: r-set, fill: none, stroke: s-thick + blue.lighten(35%))

  // Universe elements — small soft dots, placed so each sits in at
  // least one set; some are in 2- or 3-set intersections.
  let dots = (
    (-0.78,  0.35),   // set 1 only
    (-0.30,  0.55),   // 1 ∩ 2
    ( 0.78,  0.35),   // set 2 only
    (-0.40, -0.20),   // 1 ∩ 3
    ( 0.00,  0.05),   // all three
    ( 0.40, -0.20),   // 2 ∩ 3
    (-0.20, -0.65),   // set 3 only
    ( 0.30, -0.70),   // set 3 only
  )
  for d in dots {
    circle(d, radius: 0.07,
      fill: white,
      stroke: 0.7pt + luma(80))
  }
})
