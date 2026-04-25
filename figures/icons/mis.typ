#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 1pt, fill: none)
#set text(size: 7.5pt, font: "DejaVu Sans Mono")

#canvas({
  import draw: *

  let edge-stroke = (paint: black.lighten(20%), thickness: 0.8pt)
  let plain-node(position, name: none) = circle(
    position, radius: 0.13cm,
    fill: white,
    stroke: 0.6pt + black.lighten(10%),
    name: name,
  )
  let is-node(position, name: none) = circle(
    position, radius: 0.13cm,
    fill: rgb("#4e79a7"),
    stroke: 0.6pt + black.lighten(10%),
    name: name,
  )

  // Background disc.
  circle((0, 0), radius: 1.4cm,
    fill: rgb("#f6f9fe"),
    stroke: 1pt + rgb("#AAC4E9"))

  // Vertices: 3 in the independent set (top, right, lower-left) drawn blue.
  let v-top   = (-0.05, 0.85)   // IS
  let v-ur    = (0.55, 0.45)
  let v-r     = (0.95, -0.05)
  let v-lr    = (0.45, -0.7)    // IS
  let v-c     = (0.05, -0.05)
  let v-ll    = (-0.7, -0.55)
  let v-l     = (-0.85, 0.15)   // IS

  // Edges — none between {v-top, v-lr, v-l}.
  line(v-top, v-ur, stroke: edge-stroke)
  line(v-top, v-c,  stroke: edge-stroke)
  line(v-ur,  v-r,  stroke: edge-stroke)
  line(v-ur,  v-c,  stroke: edge-stroke)
  line(v-r,   v-lr, stroke: edge-stroke)
  line(v-r,   v-c,  stroke: edge-stroke)
  line(v-c,   v-ll, stroke: edge-stroke)
  line(v-c,   v-l,  stroke: edge-stroke)
  line(v-ll,  v-lr, stroke: edge-stroke)
  line(v-ll,  v-l,  stroke: edge-stroke)

  // Nodes.
  is-node(v-top)
  plain-node(v-ur)
  plain-node(v-r)
  is-node(v-lr)
  plain-node(v-c)
  plain-node(v-ll)
  is-node(v-l)
})
