#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 1pt, fill: none)

#canvas({
  import draw: *

  circle((0, 0), radius: 1.4cm,
    fill: white,
    stroke: 2pt + rgb("#AAC4E9"))

  // Three colours — exactly k = 3.
  let blue   = rgb("#4e79a7")
  let orange = rgb("#f28e2b")
  let gray   = luma(170)
  let cols   = (blue, orange, blue, orange, gray)

  let edge-stroke = (paint: black.lighten(20%), thickness: 0.8pt)

  // Pentagon (C5) — chromatic number is 3, so this graph is the smallest
  // natural example of "needs k=3 colours". Vertices coloured A B A B C.
  let R = 0.65
  let nodes = (
    (0, R),
    (R * 0.951,  R * 0.309),
    (R * 0.588, -R * 0.809),
    (-R * 0.588, -R * 0.809),
    (-R * 0.951,  R * 0.309),
  )

  // Pentagon edges.
  for i in range(5) {
    let a = nodes.at(i)
    let b = nodes.at(calc.rem(i + 1, 5))
    line(a, b, stroke: edge-stroke)
  }

  // Vertices, drawn after edges.
  for (i, p) in nodes.enumerate() {
    let c = cols.at(i)
    circle(p, radius: 0.13,
      fill: c, stroke: 0.5pt + c.darken(25%))
  }

  // "k = 3" label below the graph — explicit indicator of the number of
  // colours used.
  content((0, -1.05),
    text(14pt, weight: "bold", fill: luma(40), $k = 3$))
})
