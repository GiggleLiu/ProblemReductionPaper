#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 1pt)
#set text(size: 7.5pt, font: "DejaVu Sans Mono")
#canvas({
  import draw: *
  let red-circle(position) = circle(position, radius: 1.4cm, fill: rgb("#e42f29"), stroke: 1pt)

  circle((0, 0), radius: 1.4cm, fill: rgb("#f6f9fe"), stroke: 1pt + rgb("#AAC4E9"))
  red-circle((0, 0.5))
})