#import "lib.typ": *
#import "pixel-family/lib.typ": bob, crank

#set page(..fig-page)
#set text(..fig-text)

// Colors
#let brick-colors = (
  rgb("#4e79a7"),  // steel blue
  rgb("#59a14f"),  // green
  rgb("#e15759"),  // red
  rgb("#f28e2b"),  // orange
  rgb("#76b7b2"),  // teal
  rgb("#edc949"),  // yellow
  rgb("#af7aa1"),  // purple
)

#let col-new = rgb("#e15759")      // red — the new piece
#let col-good = rgb("#59a14f")     // green — success

#let bw = 2.2  // brick width
#let bh = 0.8  // brick height

#canvas(length: 0.45cm, {
  import draw: *

  // Helper: draw a brick wall (rows x cols, with offset pattern)
  let draw-wall(wx, wy, rows) = {
    for row in range(rows) {
      let offset = if calc.rem(row, 2) == 1 { bw / 2 } else { 0 }
      let n-bricks = if calc.rem(row, 2) == 1 { 2 } else { 3 }
      for col in range(n-bricks) {
        let bx = wx + offset + col * bw
        let by = wy + row * bh
        rect(
          (bx, by), (bx + bw, by + bh),
          fill: brick-colors.at(calc.rem(row * 3 + col, 7)),
          stroke: 0.5pt + white,
          radius: 1pt,
        )
      }
    }
  }

  // ─── Left Panel: Manual Integration ───
  let lx = 0
  let ly = 0

  // Panel border
  rect(
    (lx - 6, ly - 5.5), (lx + 6, ly + 7),
    radius: 4pt, stroke: 0.6pt + luma(180),
  )

  // Title
  content(
    (lx, ly + 6.3),
    text(7.5pt, weight: "bold", fill: fg, [Manual integration]),
  )

  // Lego wall — 4 neat rows
  let wall-x = lx - 3.3
  let wall-y = ly - 3.5
  draw-wall(wall-x, wall-y, 4)

  // The new brick jammed into the wall at a wrong angle
  let jam-cx = wall-x + bw * 1.5
  let jam-cy = wall-y + 4 * bh + bh / 2
  group({
    translate((jam-cx, jam-cy))
    rotate(25deg)
    rect(
      (-bw / 2, -bh / 2), (bw / 2, bh / 2),
      fill: col-new.lighten(30%),
      stroke: 1pt + col-new,
      radius: 1pt,
    )
    content(
      (0, 0),
      text(5pt, fill: col-new.darken(20%), [new]),
    )
  })

  // X mark — wrong
  content(
    (jam-cx + bw * 0.9, jam-cy + bh * 0.8),
    text(9pt, fill: col-new, [✗]),
  )

  // Bob standing next to wall
  content(
    (lx + 3.8, ly - 1.5),
    bob(size: 1.5cm),
  )

  // ─── Right Panel: Agentic Integration ───
  let rx = 13
  let ry = 0

  // Panel border
  rect(
    (rx - 6, ry - 5.5), (rx + 6, ry + 7),
    radius: 4pt, stroke: 0.6pt + luma(180),
  )

  // Title
  content(
    (rx, ry + 6.3),
    text(7.5pt, weight: "bold", fill: fg, [Agentic integration]),
  )

  // Lego wall — 4 neat rows + the new brick correctly placed on top
  let wall-x2 = rx - 3.3
  let wall-y2 = ry - 3.5
  draw-wall(wall-x2, wall-y2, 4)

  // New brick correctly placed (5th row, middle position)
  let new-bx = wall-x2 + bw
  let new-by = wall-y2 + 4 * bh
  rect(
    (new-bx, new-by), (new-bx + bw, new-by + bh),
    fill: col-good.lighten(40%),
    stroke: 1pt + col-good,
    radius: 1pt,
  )
  content(
    (new-bx + bw / 2, new-by + bh / 2),
    text(5pt, fill: col-good.darken(20%), [new]),
  )

  // Checkmark
  content(
    (new-bx + bw / 2, new-by + bh + 0.4),
    text(9pt, fill: col-good, [✓]),
  )

  // Bob on far left — handing a note
  content(
    (rx - 4.5, ry - 1.5),
    bob(size: 1.5cm),
  )

  // Issue note
  let note-x = rx - 3.0
  let note-y = ry + 0.0
  rect(
    (note-x, note-y), (note-x + 1.4, note-y + 1.0),
    fill: white, stroke: 0.5pt + luma(150), radius: 2pt,
  )
  content(
    (note-x + 0.7, note-y + 0.5),
    text(4.5pt, fill: fg, align(center, [issue])),
  )

  // Arrow: issue → agent
  line(
    (note-x + 1.5, note-y + 0.5),
    (rx + 0.3, note-y + 0.5),
    stroke: (thickness: 0.8pt, paint: accent),
    mark: (end: "straight", scale: 0.35),
  )

  // Crank carrying the brick toward the wall
  content(
    (rx + 1.5, ry - 1.5),
    crank(size: 1.5cm),
  )

  // Small brick above crank (being carried)
  let carry-x = rx + 1.5
  let carry-y = ry + 1.8
  rect(
    (carry-x - bw * 0.35, carry-y - bh * 0.35),
    (carry-x + bw * 0.35, carry-y + bh * 0.35),
    fill: col-good.lighten(40%),
    stroke: 0.8pt + col-good,
    radius: 1pt,
  )

  // Dashed arrow from carried brick to its place in the wall
  line(
    (carry-x + bw * 0.4, carry-y),
    (new-bx - 0.1, new-by + bh / 2),
    stroke: (thickness: 0.7pt, paint: col-good, dash: "dashed"),
    mark: (end: "straight", scale: 0.3),
  )
})
