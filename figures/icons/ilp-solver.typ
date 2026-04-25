#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 1pt, fill: none)
#set text(size: 7.5pt, font: "Helvetica")

#canvas({
  import draw: *

  // Feasible polytope (LP relaxation): regular hexagon, light orange fill.
  let R = 0.78
  let verts = (
    (R * 0.866,  R * 0.5),
    (0, R),
    (-R * 0.866, R * 0.5),
    (-R * 0.866, -R * 0.5),
    (0, -R),
    (R * 0.866, -R * 0.5),
  )
  merge-path(close: true,
    fill: rgb("#f28e2b").lighten(82%),
    stroke: (paint: rgb("#f28e2b"), thickness: 1.0pt),
    {
      for i in range(verts.len()) {
        let a = verts.at(i)
        let b = verts.at(calc.rem(i + 1, verts.len()))
        line(a, b)
      }
    })

  // Integer lattice (5×5), step 0.32.
  // Hand-listed which lattice cells fall inside the hexagon.
  let step = 0.32
  let inside-set = (
    (-2, -1), (-1, -1), (0, -1), (1, -1), (2, -1),
    (-2,  0), (-1,  0), (0,  0), (1,  0), (2,  0),
    (-2,  1), (-1,  1), (0,  1), (1,  1), (2,  1),
    (0, -2), (0, 2),
  )
  let optimum = (2, 1)

  for i in range(-2, 3) {
    for j in range(-2, 3) {
      let x = i * step
      let y = j * step
      if (i, j) == optimum {
        circle((x, y), radius: 0.13cm,
          fill: rgb("#59a14f"),
          stroke: 0.5pt + black.lighten(10%))
      } else if inside-set.contains((i, j)) {
        circle((x, y), radius: 0.075cm,
          fill: rgb("#4e79a7"),
          stroke: 0.4pt + black.lighten(10%))
      } else {
        circle((x, y), radius: 0.045cm,
          fill: luma(170),
          stroke: none)
      }
    }
  }

  // Objective gradient (small arrow in lower-left, direction = max c·x).
  line((-0.55, -0.55), (-0.10, -0.10),
    stroke: (paint: rgb("#59a14f").darken(15%), thickness: 1.0pt),
    mark: (end: "straight", scale: 0.5))
})
