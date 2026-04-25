#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 1pt, fill: none)
#set text(size: 7.5pt, font: "Helvetica")

#canvas({
  import draw: *

  // Faint integer-lattice grid lines (the "integer" of ILP, without the noise
  // of per-point dots).
  let step = 0.32
  let grid-stroke = (paint: luma(225), thickness: 0.4pt)
  let extent = 0.95
  let n = 3
  for k in range(-n, n + 1) {
    line((k * step, -extent), (k * step, extent), stroke: grid-stroke)
    line((-extent, k * step), (extent, k * step), stroke: grid-stroke)
  }

  // Feasible polytope: irregular convex pentagon (looks like a real LP region,
  // not a logo-style hexagon).
  let poly = (
    (-0.80, -0.30),
    (-0.40, 0.75),
    ( 0.55, 0.80),
    ( 0.90, 0.05),
    ( 0.35, -0.80),
  )
  merge-path(close: true,
    fill: rgb("#f28e2b").lighten(80%),
    stroke: (paint: rgb("#f28e2b").darken(5%), thickness: 1.2pt),
    {
      for i in range(poly.len()) {
        let a = poly.at(i)
        let b = poly.at(calc.rem(i + 1, poly.len()))
        line(a, b)
      }
    })

  // A few visible lattice points inside the polytope (just enough to read as
  // "integer points", not a sea of dots).
  let inside-pts = (
    (-1, -1), (0, -1), (1, -1),
    (-1,  0), (0,  0), (1,  0), (2, 0),
    (-1,  1), (0,  1), (1,  1),
    (0,  2),
  )
  for (i, j) in inside-pts {
    circle((i * step, j * step), radius: 0.055cm,
      fill: black.lighten(25%),
      stroke: none)
  }

  // ILP optimum — bright green dot at a lattice point near the polytope's
  // upper-right vertex.
  let opt = (2, 1)
  circle((opt.at(0) * step, opt.at(1) * step), radius: 0.1cm,
    fill: rgb("#59a14f"),
    stroke: 0.5pt + black.lighten(10%))

  // Objective gradient — arrow in the upper-left exterior, direction = max c·x.
  line((-0.85, 0.35), (-0.40, 0.80),
    stroke: (paint: rgb("#59a14f").darken(20%), thickness: 1.2pt),
    mark: (end: "straight", scale: 0.6))
})
