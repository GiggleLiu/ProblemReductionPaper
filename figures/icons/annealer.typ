#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 1pt, fill: none)
#set text(size: 7.5pt, font: "Helvetica")

#canvas({
  import draw: *

  // Fixed bounding box so all solver icons render at the same size.
  rect((-0.95, -0.95), (0.95, 0.95), stroke: none, fill: none)

  // Energy landscape — wavy curve: two local minima + one deeper global min.
  let pts = (
    (-0.90,  0.55),
    (-0.55, -0.05),  // local min
    (-0.25,  0.42),
    ( 0.05, -0.60),  // global min
    ( 0.40,  0.32),
    ( 0.70, -0.18),  // local min
    ( 0.90,  0.30),
  )
  hobby(..pts,
    stroke: (paint: rgb("#f28e2b").darken(5%), thickness: 1.4pt))

  // Downward "minimize" arrow above the global min (drawn before dot).
  let gmin = (0.05, -0.60)
  line((gmin.at(0), 0.82), (gmin.at(0), gmin.at(1) + 0.30),
    stroke: (paint: rgb("#59a14f").darken(20%), thickness: 1.2pt),
    mark: (end: "straight", scale: 0.6))

  // Local minima — small gray dots to emphasize "many minima".
  for lm in ((-0.55, -0.05), (0.70, -0.18)) {
    circle(lm, radius: 0.06cm,
      fill: luma(150),
      stroke: none)
  }

  // Global minimum — bright green dot.
  circle(gmin, radius: 0.12cm,
    fill: rgb("#59a14f"),
    stroke: 0.5pt + black.lighten(10%))
})
