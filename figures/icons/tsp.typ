#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 1pt, fill: none)
#set text(size: 7.5pt, font: "DejaVu Sans Mono")

#canvas({
  import draw: *

  let node(position, name: none) = circle(
    position, radius: 0.11cm,
    fill: white,
    stroke: 0.6pt + black.lighten(10%),
    name: name,
  )

  // Hexagon vertices (clockwise from top), R = 0.85.
  let R = 0.85
  let pts = (
    (0, R),
    (R * 0.866,  R * 0.5),
    (R * 0.866, -R * 0.5),
    (0, -R),
    (-R * 0.866, -R * 0.5),
    (-R * 0.866,  R * 0.5),
  )

  // Background disc.
  circle((0, 0), radius: 1.4cm,
    fill: rgb("#f6f9fe"),
    stroke: 1pt + rgb("#AAC4E9"))

  // Tour cycle (dashed blue).
  let tour-stroke = (paint: rgb("#4e79a7"), thickness: 0.9pt, dash: "densely-dashed")
  for i in range(pts.len()) {
    line(pts.at(i), pts.at(calc.rem(i + 1, pts.len())), stroke: tour-stroke)
  }

  // Nodes on top.
  for p in pts { node(p) }
})
