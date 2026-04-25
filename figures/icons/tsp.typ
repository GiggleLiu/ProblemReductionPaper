#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 1pt, fill: none)
#set text(size: 7.5pt, font: "DejaVu Sans Mono")

#canvas({
  import draw: *

  let node(position, name: none) = circle(
    position, radius: 0.10cm,
    fill: white,
    stroke: 0.6pt + black.lighten(10%),
    name: name,
  )

  // Background disc.
  circle((0, 0), radius: 1.4cm,
    fill: rgb("#f6f9fe"),
    stroke: 1pt + rgb("#AAC4E9"))

  // 8 cities — irregular scatter, looks like a real TSP instance.
  let cities = (
    ( 0.00,  0.90),   // 0 top
    ( 0.65,  0.55),   // 1 upper-right
    ( 0.95, -0.05),   // 2 right
    ( 0.50, -0.70),   // 3 lower-right
    (-0.20, -0.90),   // 4 bottom
    (-0.80, -0.40),   // 5 lower-left
    (-0.90,  0.30),   // 6 left
    (-0.45,  0.70),   // 7 interior
  )

  // Faint candidate edges in the background (a few non-tour pairs) to suggest
  // a complete graph of choices.
  let ghost-stroke = (paint: luma(220), thickness: 0.4pt)
  let ghost-pairs = (
    (0, 2), (0, 5), (1, 4), (2, 6), (3, 6), (3, 7), (5, 1), (4, 7),
  )
  for (a, b) in ghost-pairs {
    line(cities.at(a), cities.at(b), stroke: ghost-stroke)
  }

  // Chosen tour (closed cycle, no self-crossings).
  let tour = (0, 1, 2, 3, 4, 5, 6, 7)
  let tour-stroke = (paint: rgb("#4e79a7"), thickness: 1.0pt, dash: "densely-dashed")
  for i in range(tour.len()) {
    let a = tour.at(i)
    let b = tour.at(calc.rem(i + 1, tour.len()))
    line(cities.at(a), cities.at(b), stroke: tour-stroke)
  }

  // Cities on top.
  for c in cities { node(c) }
})
