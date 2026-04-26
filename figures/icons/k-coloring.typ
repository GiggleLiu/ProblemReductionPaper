#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 1pt, fill: none)
#set text(size: 7.5pt, font: "DejaVu Sans Mono")

#canvas({
  import draw: *

  let node(position, fill-col, name: none) = circle(
    position, radius: 0.13cm,
    fill: fill-col,
    stroke: 0.5pt + black.lighten(20%),
    name: name,
  )
  let edge-stroke = (paint: black.lighten(20%), thickness: 0.8pt)

  // Outer pentagon vertices (clockwise from top), R = 0.95.
  let R = 0.95
  let yellow-pt = (0, R)
  let green-pt  = (R * 0.951,  R * 0.309)
  let purple-pt = (R * 0.588, -R * 0.809)
  let blue-pt   = (-R * 0.588, -R * 0.809)
  let red-pt    = (-R * 0.951,  R * 0.309)
  let center-pt = (0, 0)

  // Background disc.
  circle((0, 0), radius: 1.4cm,
    fill: white,
    stroke: 2pt + rgb("#AAC4E9"))

  // Pentagon ring.
  line(yellow-pt, green-pt,  stroke: edge-stroke)
  line(green-pt,  purple-pt, stroke: edge-stroke)
  line(purple-pt, blue-pt,   stroke: edge-stroke)
  line(blue-pt,   red-pt,    stroke: edge-stroke)
  line(red-pt,    yellow-pt, stroke: edge-stroke)

  // Spokes from center hub.
  line(center-pt, yellow-pt, stroke: edge-stroke)
  line(center-pt, green-pt,  stroke: edge-stroke)
  line(center-pt, purple-pt, stroke: edge-stroke)
  line(center-pt, blue-pt,   stroke: edge-stroke)
  line(center-pt, red-pt,    stroke: edge-stroke)

  // Nodes (drawn after edges so they sit on top).
  node(yellow-pt, rgb("#f1c40f"))
  node(green-pt,  rgb("#59a14f"))
  node(purple-pt, rgb("#9b59b6"))
  node(blue-pt,   rgb("#4e79a7"))
  node(red-pt,    rgb("#e42f29"))
  node(center-pt, rgb("#f28e2b"))
})
