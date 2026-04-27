#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 1pt, fill: none)

#canvas({
  import draw: *

  circle((0, 0), radius: 1.4cm, fill: white, stroke: 2pt + rgb("#AAC4E9"))

  let blue   = rgb("#4e79a7")
  let green  = rgb("#59a14f")
  let orange = rgb("#f28e2b")
  let purple = rgb("#83379d")

  // Three overlapping translucent discs = three "sets". Together they
  // cover all the universe dots drawn on top.
  circle((-0.55, 0.30), radius: 0.62,
    fill: blue.lighten(75%),
    stroke: 1pt + blue.darken(5%))
  circle(( 0.40, 0.45), radius: 0.62,
    fill: green.lighten(75%),
    stroke: 1pt + green.darken(5%))
  circle(( 0.10, -0.55), radius: 0.62,
    fill: orange.lighten(70%),
    stroke: 1pt + orange.darken(5%))

  // Universe dots — every dot is enclosed in at least one coloured set.
  let dots = (
    (-0.78, 0.45),
    (-0.30, 0.55),
    ( 0.20, 0.65),
    ( 0.55, 0.30),
    (-0.20, 0.10),
    (-0.30, -0.40),
    ( 0.45, -0.55),
  )
  for d in dots {
    circle(d, radius: 0.10, fill: black.lighten(15%), stroke: none)
  }
})
