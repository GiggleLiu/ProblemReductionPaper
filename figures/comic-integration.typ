#import "lib.typ": *
#import "pixel-family/lib.typ": bob, crank

#set page(..fig-page)
#set text(..fig-text)

// Muted palette
#let col-brick = luma(200)           // light gray bricks
#let col-brick-stroke = luma(255)    // white gaps
#let col-new = rgb("#e15759")        // red — the new piece (wrong)
#let col-good = rgb("#59a14f")       // green — success

#let bw = 2.2  // brick width
#let bh = 0.8  // brick height

#canvas(length: 0.45cm, {
  import draw: *
  let charsize = 0.6cm

  // Helper: draw a brick wall in uniform gray
  let draw-wall(wx, wy, rows) = {
    for row in range(rows) {
      let offset = if calc.rem(row, 2) == 1 { bw / 2 } else { 0 }
      let n-bricks = if calc.rem(row, 2) == 1 { 2 } else { 3 }
      for col in range(n-bricks) {
        let bx = wx + offset + col * bw
        let by = wy + row * bh
        rect(
          (bx, by), (bx + bw, by + bh),
          fill: col-brick,
          stroke: 0.5pt + col-brick-stroke,
          radius: 1pt,
        )
      }
    }
  }

  // ─── Left Panel: Manual Integration ───
  let lx = 0
  let ly = 0

  content(
    (lx, ly + 1.8),
    text(7.5pt, weight: "bold", fill: fg, [Manual integration]),
  )

  let wall-x = lx - 3.3
  let wall-y = ly - 3.5
  draw-wall(wall-x, wall-y, 4)

  // New brick jammed at wrong angle
  let jam-cx = wall-x + bw * 1.5
  let jam-cy = wall-y + 4 * bh + bh / 2
  group({
    translate((jam-cx, jam-cy))
    rotate(25deg)
    let dx = 2.9
    let dy = -3.6
    rect(
      (dx - bw / 2, dy - bh / 2), (dx+bw / 2, dy+bh / 2),
      fill: col-good,
      stroke: none,
      radius: 1pt,
    )
  })

  // X mark
  content(
    (3 + jam-cx + bw * 0.9, jam-cy + bh * 0.8),
    text(8pt, fill: col-new, [?]),
  )

  // Bob — small
  content(
    (lx + 4.8, ly - 0.3),
    bob(size: charsize),
  )

  // ─── Right Panel: Agentic Integration ───
  let rx = 13
  let ry = 0

  content(
    (rx, ry + 1.8),
    text(7.5pt, weight: "bold", fill: fg, [Agentic integration]),
  )

  let wall-x2 = rx - 3.3
  let wall-y2 = ry - 3.5
  draw-wall(wall-x2, wall-y2, 4)

  // New brick correctly placed
  let new-bx = wall-x2 + 2.5 * bw
  let new-by = wall-y2 + 1 * bh
  rect(
    (new-bx, new-by), (new-bx + bw, new-by + bh),
    fill: col-good,
    stroke: none,
    radius: 1pt,
  )

  // Bob handing issue
  content(
    (rx + 4.8, ry - 0.3),
    bob(size: charsize),
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

  // Crank carrying brick
  content(
    (rx + 5.2, ry - 2.5),
    crank(size: charsize),
  )
})
