#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 1pt, fill: none)

#canvas({
  import draw: *

  circle((0, 0), radius: 1.4cm,
    fill: white,
    stroke: 2pt + rgb("#AAC4E9"))

  let stroke-col = black.lighten(10%)
  let cell-h = 0.28
  let unit  = 0.10

  // Draw a row of cells starting at left-edge x0; each cell's width is
  // its value times `unit`.
  let row-at(x0, cy, widths, fill-col) = {
    let prefix = widths.fold((0,), (acc, w) => acc + (acc.last() + w,))
    for (i, w) in widths.enumerate() {
      let lx = x0 + prefix.at(i) * unit
      let rx = x0 + prefix.at(i + 1) * unit
      rect((lx, cy - cell-h / 2), (rx, cy + cell-h / 2),
        fill: fill-col,
        stroke: 0.7pt + stroke-col,
        radius: 0.04)
    }
  }

  let centered-row(cy, widths, fill-col) = {
    let total = widths.sum() * unit
    row-at(-total / 2, cy, widths, fill-col)
  }

  let blue = rgb("#4e79a7")

  // Top row: full sequence (5, 3, 4, 2, 6) — sum 20. Neutral fill marks
  // them as a single multiset before partitioning.
  centered-row(0.60, (5, 3, 4, 2, 6), luma(225))

  // Down arrow — "split into two halves".
  line((0, 0.32), (0, -0.05),
    stroke: (paint: black.lighten(20%), thickness: 0.9pt, cap: "round"),
    mark: (end: "straight", scale: 0.5))

  // Two sub-rows, each summing to 10. Same blue hue, two shades — the
  // shade just distinguishes the two halves; equal widths mean equal sums.
  let half-w = 10 * unit
  let gap    = 0.07
  // Left half: (4, 6) — darker shade.
  row-at(-half-w - gap, -0.55, (4, 6), blue.lighten(35%))
  // Right half: (5, 3, 2) — lighter shade.
  row-at(gap, -0.55, (5, 3, 2), blue.lighten(65%))
})
