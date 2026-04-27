#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 1pt, fill: none)
#set text(size: 7.5pt, font: "Helvetica")

#canvas({
  import draw: *

  // Fixed bounding box so all solver icons render at the same size.
  rect((-0.95, -0.95), (0.95, 0.95), stroke: none, fill: none)

  // Energy = baseline − sum of Gaussian wells. Three wells of different depth
  // produce a smooth multi-modal landscape with one clearly global minimum.
  let baseline = 0.35
  let wells = (
    (-0.55, 0.55, 0.20),  // (center, depth, sigma) — local
    ( 0.05, 1.00, 0.22),  // GLOBAL minimum (deepest)
    ( 0.55, 0.70, 0.20),  // local
  )
  let energy(x) = {
    let v = baseline
    for (xc, depth, sig) in wells {
      v -= depth * calc.exp(-calc.pow((x - xc) / sig, 2))
    }
    v
  }

  // Sample densely so the curve looks analytic.
  let xmin = -0.88
  let xmax = 0.88
  let n = 80
  let pts = ()
  for k in range(n + 1) {
    let x = xmin + k / n * (xmax - xmin)
    pts.push((x, energy(x)))
  }
  line(..pts,
    stroke: (paint: rgb("#5a6878").darken(5%), thickness: 1.4pt))

  // Global-minimum target.
  let gmin = (0.05, energy(0.05))

  // Downward "minimize" arrow above the global min (drawn before the dot).
  line((gmin.at(0), 0.85), (gmin.at(0), gmin.at(1) + 0.28),
    stroke: (paint: rgb("#59a14f").darken(20%), thickness: 1.2pt),
    mark: (end: "straight", scale: 0.6))

  // Local minima — small gray dots.
  for x in (-0.55, 0.55) {
    circle((x, energy(x)),
      radius: 0.06cm, fill: luma(150), stroke: none)
  }

  // Global minimum — bright green dot.
  circle(gmin, radius: 0.12cm,
    fill: rgb("#59a14f"),
    stroke: 0.5pt + black.lighten(10%))
})
