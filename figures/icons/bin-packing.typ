#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 1pt, fill: none)

#canvas({
  import draw: *

  circle((0, 0), radius: 1.4cm,
    fill: white,
    stroke: 2pt + rgb("#AAC4E9"))

  // Three bins of identical capacity (8 size units). Item heights encode
  // sizes; the third bin is partially full to contrast with packing
  // patterns that exactly fill the capacity.
  let bw          = 0.48
  let unit-h      = 0.18
  let capacity    = 8
  let wall-h      = capacity * unit-h
  let bottom      = -0.72
  let top         = bottom + wall-h
  let wall-stroke = (paint: black.lighten(10%),
                     thickness: 1.1pt,
                     cap: "round",
                     join: "round")

  let bin(cx, items) = {
    let xL = cx - bw / 2
    let xR = cx + bw / 2
    // U-shaped open-top walls.
    line((xL, top), (xL, bottom), (xR, bottom), (xR, top),
      stroke: wall-stroke)

    // Stack items from bottom up; each item's drawn height = size * unit-h.
    let prefix = items.fold((0,),
      (acc, it) => acc + (acc.last() + it.at(1) * unit-h,))
    for (i, it) in items.enumerate() {
      let (col, _) = it
      let y0 = bottom + prefix.at(i)
      let y1 = bottom + prefix.at(i + 1)
      rect((xL + 0.025, y0 + 0.025), (xR - 0.025, y1 - 0.025),
        fill: col,
        stroke: 0.5pt + col.darken(20%),
        radius: 0.045)
    }
  }

  // Items use a single blue palette in different shades — heights still
  // encode sizes; the shade variation just separates adjacent items.
  let blue = rgb("#4e79a7")
  let item-shades = (
    blue.darken(10%),
    blue.lighten(20%),
    blue.lighten(50%),
    blue.lighten(35%),
  )

  // Bin 1 (left): exactly full — two items (5 + 3 = 8).
  bin(-0.78, ((item-shades.at(0), 5), (item-shades.at(2), 3)))

  // Bin 2 (middle): exactly full — three items (4 + 3 + 1 = 8).
  bin( 0.00, (
    (item-shades.at(1), 4),
    (item-shades.at(3), 3),
    (item-shades.at(0), 1),
  ))

  // Bin 3 (right): partially full — two items (3 + 2 = 5/8).
  bin( 0.78, ((item-shades.at(0), 3), (item-shades.at(2), 2)))
})
