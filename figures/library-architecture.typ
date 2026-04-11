#import "lib.typ": *

#set page(..fig-page)
#set text(..fig-text)

#canvas(length: 0.48cm, {
  import draw: *

  // Use lib.typ palette only: accent shades + greys
  let col-top  = accent                    // interfaces
  let col-mid  = accent.desaturate(40%)    // core — muted accent
  let col-bot  = luma(120)                 // infrastructure — grey

  // ── Layout ──
  let bw = 6.2
  let bh = 1.5
  let gx = 0.6
  let gy = 0.6

  let row(y, col, labels) = {
    for (i, label) in labels.enumerate() {
      let x = i * (bw + gx)
      rect(
        (x, y), (x + bw, y - bh),
        radius: 3pt,
        fill: col.lighten(82%),
        stroke: (thickness: 0.8pt, paint: col.darken(10%)),
        name: "r" + str(calc.round(y)) + "-" + str(i),
      )
      content(
        "r" + str(calc.round(y)) + "-" + str(i), anchor: "center",
        text(8pt, weight: "bold", fill: fg, label),
      )
    }
  }

  let lx = -0.5

  // Top row: Interfaces
  let y0 = 0
  row(y0, col-top, ([`pred` CLI], [PDF Manual]))
  content((lx, y0 - bh/2), anchor: "east",
    text(10pt, fill: col-top.darken(20%), weight: "bold", [Interfaces]))

  // Middle row: Core
  let y1 = y0 - bh - gy
  row(y1, col-mid, ([Problem Types], [Reduction Rules], [Example Database]))
  content((lx, y1 - bh/2), anchor: "east",
    text(10pt, fill: col-mid.darken(20%), weight: "bold", [Core]))

  // Bottom row: Infrastructure
  let y2 = y1 - bh - gy
  row(y2, col-bot, ([Solvers], [Symbolic Engine]))
  content((lx, y2 - bh/2), anchor: "east",
    text(10pt, fill: col-bot.darken(20%), weight: "bold", [Infrastructure]))
})
