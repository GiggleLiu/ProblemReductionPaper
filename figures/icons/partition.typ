#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 1pt, fill: none)
#set text(size: 7.5pt, font: "DejaVu Sans Mono")

#canvas({
  import draw: *

  // Background disc.
  circle((0, 0), radius: 1.4cm,
    fill: rgb("#f6f9fe"),
    stroke: 1pt + rgb("#AAC4E9"))

  // A row of small numbered cells.
  // cx, cy: center of the row. nums: list of label content.
  let cell-w = 0.22
  let cell-h = 0.28
  let cell-row(cx, cy, nums, stroke-col) = {
    let n = nums.len()
    let total = n * cell-w
    let x0 = cx - total / 2
    for (i, val) in nums.enumerate() {
      let lx = x0 + i * cell-w
      let rx = lx + cell-w
      rect((lx, cy - cell-h / 2), (rx, cy + cell-h / 2),
        fill: white,
        stroke: 0.7pt + stroke-col,
        radius: 0.03)
      content(((lx + rx) / 2, cy),
        text(6.5pt, weight: "bold", fill: stroke-col, val))
    }
  }

  // Top: full sequence.
  cell-row(0, 0.7, ([3], [1], [4], [2], [2], [1]), black.lighten(10%))

  // Down arrow.
  line((0, 0.45), (0, 0.18),
    stroke: (paint: black.lighten(20%), thickness: 0.7pt),
    mark: (end: "straight", scale: 0.4))

  // Bottom: two halves, with "=" between.
  cell-row(-0.55, -0.15, ([3], [1], [2]), rgb("#4e79a7"))
  content((0.0, -0.15), text(8pt, weight: "bold", fill: black.lighten(20%), [=]))
  cell-row(0.55, -0.15, ([4], [2], [1]), rgb("#e42f29"))
})
