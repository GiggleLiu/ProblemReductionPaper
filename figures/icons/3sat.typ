#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 1pt, fill: none)

#canvas({
  import draw: *

  circle((0, 0), radius: 1.4cm, fill: white, stroke: 2pt + rgb("#AAC4E9"))

  let red   = rgb("#e42f29")
  let blue  = rgb("#4e79a7")
  let green = rgb("#59a14f")

  let gate-stroke = (paint: luma(30), thickness: 1.6pt, cap: "round", join: "round")
  let wire-stroke = (paint: luma(70), thickness: 1.1pt, cap: "round")
  let neg-stroke  = (paint: luma(20), thickness: 1.7pt, cap: "round")

  // OR-gate body: convex front + concave back (the canonical "OR gate"
  // glyph). The back curve gently opens to the right.
  let xL = -0.20
  let xR =  0.85
  let H  =  0.68
  merge-path(close: true, stroke: gate-stroke, fill: white, {
    // Top edge: from (xL, H) sweeps down-right to the tip (xR, 0).
    bezier((xL, H), (xR, 0), (xL + 0.55, H), (xR - 0.10, 0.45))
    // Bottom edge: from the tip back to (xL, -H).
    bezier((xR, 0), (xL, -H), (xR - 0.10, -0.45), (xL + 0.55, -H))
    // Back curve: concave, opening rightward.
    bezier((xL, -H), (xL, H), (xL + 0.30, -0.32), (xL + 0.30, 0.32))
  })

  // Three coloured input literals on the left; the middle one is negated
  // (overhead bar). Wires run from each node to the back of the gate.
  let r = 0.18
  let in-x = -0.85
  let inputs = (
    (green, 0.45,  false),
    (red,   0.00,  true),
    (blue, -0.45,  false),
  )
  for (col, y, neg) in inputs {
    // Wire — meets the curved back roughly where the back bows in.
    line((in-x + r, y), (xL + 0.16, y), stroke: wire-stroke)
    // Coloured literal node.
    circle((in-x, y), radius: r,
      fill: col, stroke: 0.7pt + col.darken(25%))
    if neg {
      line((in-x - r * 0.85, y + r + 0.13),
           (in-x + r * 0.85, y + r + 0.13),
        stroke: neg-stroke)
    }
  }

  // Output wire ending in a small dark node (the clause's truth value).
  line((xR, 0), (xR + 0.30, 0), stroke: wire-stroke)
  circle((xR + 0.30, 0), radius: 0.10,
    fill: luma(30), stroke: none)
})
