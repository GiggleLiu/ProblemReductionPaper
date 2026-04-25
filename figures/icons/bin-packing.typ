#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 1pt, fill: none)
#set text(size: 7.5pt, font: "Helvetica")

#canvas({
  import draw: *

  // Background disc.
  circle((0, 0), radius: 1.4cm,
    fill: rgb("#f6f9fe"),
    stroke: 2pt + rgb("#AAC4E9"))

  // One bin: U-shaped wall (no top) + a stack of items.
  // Items: list of (color, label).
  let bin(cx, items) = {
    let bw = 0.48       // bin inner width
    let item-h = 0.32   // each item height
    let bottom = -0.80
    let wall-h = 1.38   // total wall height
    let wall = (paint: black.lighten(10%), thickness: 1.0pt)

    // Walls (left, bottom, right) — open top.
    line((cx - bw / 2, bottom + wall-h), (cx - bw / 2, bottom), stroke: wall)
    line((cx - bw / 2, bottom), (cx + bw / 2, bottom), stroke: wall)
    line((cx + bw / 2, bottom), (cx + bw / 2, bottom + wall-h), stroke: wall)

    // Stack items from bottom up.
    for (i, it) in items.enumerate() {
      let (col, label) = it
      let y0 = bottom + i * item-h
      let y1 = y0 + item-h
      rect((cx - bw / 2 + 0.023, y0 + 0.023), (cx + bw / 2 - 0.023, y1 - 0.023),
        fill: col,
        stroke: 0.5pt + black.lighten(20%),
        radius: 0.045)
      content((cx, (y0 + y1) / 2),
        text(7.5pt, weight: "bold", fill: white, label))
    }
  }

  // Bin 1: green 6 on top, purple 4 below.
  bin(-0.80, ((rgb("#83379d"), [4]), (rgb("#59a14f"), [6])))

  // Bin 2: yellow 5 on top, red 3 below.
  bin(0.0, ((rgb("#e42f29"), [3]), (rgb("#f1c40f"), [5])))

  // Bin 3: teal 6, gray 2, blue 2 (bottom to top).
  bin(0.80, (
    (rgb("#4ab39c"), [6]),
    (rgb("#9aa0a6"), [2]),
    (rgb("#4e79a7"), [2]),
  ))
})
