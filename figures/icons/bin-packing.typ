#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 1pt, fill: none)

#canvas({
  import draw: *

  circle((0, 0), radius: 1.4cm,
    fill: white,
    stroke: 2pt + rgb("#AAC4E9"))

  // One bin: U-shaped wall (no top) + a stack of coloured items. Item
  // *heights* encode the size — no numeric labels needed.
  let bin(cx, items) = {
    let bw = 0.48
    let unit-h = 0.18    // height per unit-of-size
    let bottom = -0.85
    let wall-h = 1.55
    let wall = (paint: black.lighten(10%), thickness: 1.0pt)

    // Walls (left, bottom, right) — open top.
    line((cx - bw / 2, bottom + wall-h), (cx - bw / 2, bottom), stroke: wall)
    line((cx - bw / 2, bottom), (cx + bw / 2, bottom), stroke: wall)
    line((cx + bw / 2, bottom), (cx + bw / 2, bottom + wall-h), stroke: wall)

    // Stack items from bottom up; each item's drawn height = size * unit-h.
    let prefix-sums = items.fold((0,), (acc, it) => acc + (acc.last() + it.at(1) * unit-h,))
    for (i, it) in items.enumerate() {
      let (col, _) = it
      let y0 = bottom + prefix-sums.at(i)
      let y1 = bottom + prefix-sums.at(i + 1)
      rect((cx - bw / 2 + 0.025, y0 + 0.025), (cx + bw / 2 - 0.025, y1 - 0.025),
        fill: col,
        stroke: 0.5pt + black.lighten(25%),
        radius: 0.045)
    }
  }

  // Bin 1 (left): purple-4 below, green-6 on top  →  total 10
  bin(-0.80, ((rgb("#83379d"), 4), (rgb("#59a14f"), 6)))

  // Bin 2 (middle): red-3 below, yellow-5 on top  →  total 8
  bin( 0.0,  ((rgb("#e42f29"), 3), (rgb("#f1c40f"), 5)))

  // Bin 3 (right): teal-6, gray-2, blue-2  →  total 10
  bin( 0.80, (
    (rgb("#4ab39c"), 6),
    (rgb("#9aa0a6"), 2),
    (rgb("#4e79a7"), 2),
  ))
})
