#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 1pt, fill: none)

#canvas({
  import draw: *

  circle((0, 0), radius: 1.4cm,
    fill: white,
    stroke: 2pt + rgb("#AAC4E9"))

  let stroke-col = black.lighten(10%)
  let cell-h = 0.34
  let unit  = 0.13

  // A row of cells whose widths are proportional to their values; values
  // are encoded by width alone (no numeric labels).
  let row(cy, widths, cols) = {
    let prefix = widths.fold((0,), (acc, w) => acc + (acc.last() + w,))
    let total = prefix.last() * unit
    let x0 = -total / 2
    for (i, w) in widths.enumerate() {
      let lx = x0 + prefix.at(i) * unit
      let rx = x0 + prefix.at(i + 1) * unit
      rect((lx, cy - cell-h / 2), (rx, cy + cell-h / 2),
        fill: cols.at(i),
        stroke: 0.7pt + stroke-col,
        radius: 0.04)
    }
  }

  let blue = rgb("#4e79a7")
  let red  = rgb("#e42f29")
  let neutral = (luma(180), luma(160), luma(180), luma(160), luma(180), luma(160))
  let blue-shades = (blue.lighten(45%), blue.lighten(60%), blue.lighten(25%))
  let red-shades  = (red.lighten(45%),  red.lighten(60%),  red.lighten(25%))

  // Top row: full sequence (1, 1, 5, 2, 3, 4) — sum 16.
  row(0.70, (1, 1, 5, 2, 3, 4), neutral)

  // Down arrow.
  line((0, 0.40), (0, -0.05),
    stroke: (paint: black.lighten(20%), thickness: 0.9pt, cap: "round"),
    mark: (end: "straight", scale: 0.5))

  // Two sub-rows, each with the same total width (= equal-sum partition).
  // Left side: (4, 1, 3) sum 8.   Right side: (2, 5, 1) sum 8.
  let half-shift = (8 / 2) * unit + 0.08   // half-row width + small gap
  let left-row(cy, widths, cols) = {
    let prefix = widths.fold((0,), (acc, w) => acc + (acc.last() + w,))
    let total = prefix.last() * unit
    let x0 = -half-shift - total
    for (i, w) in widths.enumerate() {
      let lx = x0 + prefix.at(i) * unit
      let rx = x0 + prefix.at(i + 1) * unit
      rect((lx, cy - cell-h / 2), (rx, cy + cell-h / 2),
        fill: cols.at(i),
        stroke: 0.7pt + stroke-col,
        radius: 0.04)
    }
  }
  let right-row(cy, widths, cols) = {
    let prefix = widths.fold((0,), (acc, w) => acc + (acc.last() + w,))
    let x0 = half-shift
    for (i, w) in widths.enumerate() {
      let lx = x0 + prefix.at(i) * unit
      let rx = x0 + prefix.at(i + 1) * unit
      rect((lx, cy - cell-h / 2), (rx, cy + cell-h / 2),
        fill: cols.at(i),
        stroke: 0.7pt + stroke-col,
        radius: 0.04)
    }
  }
  left-row(-0.65, (4, 1, 3), blue-shades)
  right-row(-0.65, (2, 5, 1), red-shades)
})
