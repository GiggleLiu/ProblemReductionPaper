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
      (dx - bw / 2, dy - bh / 2), (dx + bw / 2, dy + bh / 2),
      fill: col-good,
      stroke: none,
      radius: 1pt,
    )
  })

  // ? mark
  content(
    (3 + jam-cx + bw * 0.9, jam-cy + bh * 0.8),
    text(8pt, fill: col-new, [?]),
  )

  // Bob
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

  // New brick correctly placed on top row (middle of offset row 4)
  let new-bx = wall-x2 + bw / 2   // offset row position
  let new-by = wall-y2 + 4 * bh   // top of wall
  rect(
    (new-bx, new-by), (new-bx + bw, new-by + bh),
    fill: col-good,
    stroke: none,
    radius: 1pt,
  )

  // --- Robotic arm growing from wall surface ---
  let arm-col = accent
  let joint-r = 0.22
  let arm-thick = 2.5pt

  // Base: on top of wall, right side
  let wall-top = wall-y2 + 4 * bh
  let base-x = wall-x2 + 2.5 * bw   // right portion of wall top
  rect(
    (base-x - 0.5, wall-top), (base-x + 0.5, wall-top + 0.3),
    fill: arm-col.lighten(40%),
    stroke: 0.6pt + arm-col,
    radius: (top-left: 2pt, top-right: 2pt),
  )

  // Joint 1 (shoulder)
  let j1 = (base-x, wall-top + 0.3)
  circle(j1, radius: joint-r, fill: arm-col.lighten(60%), stroke: 0.6pt + arm-col)

  // Upper arm: arches up and to the right (away from wall)
  let j2 = (base-x + 2.2, wall-top + 2.5)
  line(j1, j2, stroke: (thickness: arm-thick, paint: arm-col.lighten(30%)))

  // Joint 2 (elbow)
  circle(j2, radius: joint-r, fill: arm-col.lighten(60%), stroke: 0.6pt + arm-col)

  // Forearm: reaches back left and down to hover above the new brick
  let wrist-x = new-bx + bw / 2
  let wrist-y = new-by + bh + 0.5
  let j3 = (wrist-x, wrist-y)
  line(j2, j3, stroke: (thickness: arm-thick, paint: arm-col.lighten(50%)))

  // Joint 3 (wrist)
  circle(j3, radius: joint-r * 0.75, fill: arm-col.lighten(60%), stroke: 0.6pt + arm-col)

  // Gripper: two fingers pointing down, tips curling inward
  let grip-spread = 0.45
  let finger-len = 0.55
  let tip-len = 0.2
  // Left finger
  let lf-end = (wrist-x - grip-spread, wrist-y - finger-len)
  line(j3, lf-end, stroke: (thickness: 1.4pt, paint: arm-col))
  line(lf-end, (wrist-x - grip-spread + tip-len, wrist-y - finger-len - 0.15),
    stroke: (thickness: 1.4pt, paint: arm-col))
  // Right finger
  let rf-end = (wrist-x + grip-spread, wrist-y - finger-len)
  line(j3, rf-end, stroke: (thickness: 1.4pt, paint: arm-col))
  line(rf-end, (wrist-x + grip-spread - tip-len, wrist-y - finger-len - 0.15),
    stroke: (thickness: 1.4pt, paint: arm-col))

  // Bob on the right with issue note
  content(
    (rx + 4.8, ry - 0.3),
    bob(size: charsize),
  )

  // Issue note (positioned clearly to right of wall, below Bob)
  let note-x = rx + 4.0
  let note-y = ry - 2.0
  rect(
    (note-x, note-y), (note-x + 1.4, note-y + 1.0),
    fill: white, stroke: 0.5pt + luma(150), radius: 2pt,
  )
  content(
    (note-x + 0.7, note-y + 0.5),
    text(4.5pt, fill: fg, align(center, [issue])),
  )
})
