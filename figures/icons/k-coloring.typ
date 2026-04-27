#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 1pt, fill: none)

#canvas({
  import draw: *

  circle((0, 0), radius: 1.4cm,
    fill: white,
    stroke: 2pt + rgb("#AAC4E9"))

  // Three shades of blue used as the three colour classes — proper
  // 3-colouring of the pentagon (C5).
  let blue = rgb("#4e79a7")
  let c-dark   = blue.darken(35%)
  let c-medium = blue
  let c-light  = blue.lighten(55%)
  let cols     = (c-dark, c-medium, c-dark, c-medium, c-light)

  let edge-stroke = (paint: black.lighten(20%), thickness: 0.8pt)

  // Pentagon vertices.
  let R = 0.85
  let nodes = (
    (0, R),
    (R * 0.951,  R * 0.309),
    (R * 0.588, -R * 0.809),
    (-R * 0.588, -R * 0.809),
    (-R * 0.951,  R * 0.309),
  )

  for i in range(5) {
    let a = nodes.at(i)
    let b = nodes.at(calc.rem(i + 1, 5))
    line(a, b, stroke: edge-stroke)
  }

  for (i, p) in nodes.enumerate() {
    let c = cols.at(i)
    circle(p, radius: 0.15,
      fill: c, stroke: 0.5pt + c.darken(25%))
  }
})
