#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 1pt, fill: none)

#canvas({
  import draw: *

  circle((0, 0), radius: 1.4cm, fill: white, stroke: 2pt + rgb("#AAC4E9"))

  let blue = rgb("#4e79a7")
  let tour-stroke = (paint: blue,
                     thickness: 1.4pt,
                     cap: "round",
                     join: "round")

  // 7 cities — irregular scatter (one interior point so the tour has a
  // visible "detour" rather than just hugging the perimeter).
  let cities = (
    (-0.20,  0.85),    // 0  top
    ( 0.70,  0.55),    // 1  upper-right
    ( 0.95, -0.10),    // 2  right
    ( 0.40, -0.80),    // 3  lower-right
    (-0.55, -0.70),    // 4  lower-left
    (-0.95,  0.05),    // 5  left
    (-0.05,  0.10),    // 6  interior
  )

  // Tour: 0 → 1 → 2 → 3 → 4 → 5 → 6 → 0  (no self-crossings).
  let tour-order = (0, 1, 2, 3, 4, 5, 6, 0)
  let tour-points = tour-order.map(i => cities.at(i))
  line(..tour-points, stroke: tour-stroke)

  // Cities — filled dots on top.
  for c in cities {
    circle(c, radius: 0.11,
      fill: blue,
      stroke: 0.6pt + blue.darken(25%))
  }
})
