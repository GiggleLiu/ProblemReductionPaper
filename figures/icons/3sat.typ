#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 1pt, fill: none)

#canvas({
  import draw: *

  circle((0, 0), radius: 1.4cm, fill: white, stroke: 2pt + rgb("#AAC4E9"))

  let red   = rgb("#e42f29")
  let blue  = rgb("#4e79a7")
  let green = rgb("#59a14f")
  let neg-stroke = (paint: luma(30), thickness: 1.8pt, cap: "round")

  // 3 clauses × 3 literals = 9 colored discs. Some literals are negated
  // (horizontal bar above the disc). Colors encode the variable identity
  // (green = x, red = y, blue = z); no text needed.
  let r = 0.22
  let xs = (-0.60, 0.0, 0.60)
  let ys = (0.70, 0.0, -0.70)
  let clauses = (
    // (color, negated?) — visual analogue of  (x ∨ ¬y ∨ z)
    ((green, false), (red, true),  (blue, false)),
    // (¬x ∨ y ∨ ¬z)
    ((green, true),  (red, false), (blue, true)),
    // (¬y ∨ z ∨ ¬x)
    ((red, true),    (blue, false), (green, true)),
  )

  for (i, clause) in clauses.enumerate() {
    let y = ys.at(i)
    for (j, item) in clause.enumerate() {
      let (col, neg) = item
      let x = xs.at(j)
      circle((x, y), radius: r,
        fill: col, stroke: 0.6pt + col.darken(25%))
      if neg {
        line((x - r * 0.8, y + r + 0.13),
             (x + r * 0.8, y + r + 0.13),
          stroke: neg-stroke)
      }
    }
  }
})
