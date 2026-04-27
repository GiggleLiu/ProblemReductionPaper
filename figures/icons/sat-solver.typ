#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 1pt, fill: none)
#set text(size: 7.5pt, font: "Helvetica")

#canvas({
  import draw: *

  // Fixed bounding box so all solver icons render at the same size.
  rect((-0.95, -0.95), (0.95, 0.95), stroke: none, fill: none)

  let edge-stroke = (paint: black.lighten(20%), thickness: 0.7pt)

  // Internal node (small white circle).
  let internal(p) = circle(
    p, radius: 0.10cm,
    fill: white,
    stroke: 0.6pt + black.lighten(10%),
  )
  // Leaf node: ✓ (sat) or ✗ (conflict). SAT is solid slate; conflicts
  // are drawn lighter so the satisfying branch reads as the "answer".
  let leaf-sat(p) = {
    circle(p, radius: 0.16cm,
      fill: rgb("#5a6878"),
      stroke: 0.5pt + black.lighten(10%))
    content(p, text(7pt, weight: "bold", fill: white, [#sym.checkmark]))
  }
  let leaf-bad(p) = {
    circle(p, radius: 0.16cm,
      fill: rgb("#5a6878").lighten(50%),
      stroke: 0.5pt + black.lighten(10%))
    content(p, text(7pt, weight: "bold", fill: white, [#sym.crossmark]))
  }

  // Tree positions.
  let root = (0, 0.85)
  let il   = (-0.50, 0.20)
  let ir   = (0.50, 0.20)
  let l1 = (-0.78, -0.70)
  let l2 = (-0.26, -0.70)
  let l3 = (0.26, -0.70)
  let l4 = (0.78, -0.70)

  // Highlighted successful path: root -> il -> l2.
  let path-stroke = (paint: rgb("#4e79a7"), thickness: 1.4pt)

  // Edges first (so nodes draw on top).
  line(root, il, stroke: path-stroke)
  line(root, ir, stroke: edge-stroke)
  line(il, l1,   stroke: edge-stroke)
  line(il, l2,   stroke: path-stroke)
  line(ir, l3,   stroke: edge-stroke)
  line(ir, l4,   stroke: edge-stroke)

  // Edge labels — 0/1 branch decisions.
  let label(p, txt) = content(p,
    text(5pt, fill: black.lighten(20%), txt),
    frame: "rect", fill: white, padding: 0.01, stroke: none)
  label((-0.30, 0.53), [0])
  label((0.30, 0.53),  [1])
  label((-0.70, -0.25), [0])
  label((-0.34, -0.25), [1])
  label((0.34, -0.25),  [0])
  label((0.70, -0.25),  [1])

  // Nodes on top.
  internal(root)
  internal(il)
  internal(ir)
  leaf-bad(l1)
  leaf-sat(l2)
  leaf-bad(l3)
  leaf-bad(l4)
})
