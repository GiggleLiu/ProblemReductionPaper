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

  // --- Robotic arm growing from wall surface ---
  let arm-col = accent
  let joint-r = 0.2
  let arm-thick = 2.2pt
  let wall-top = wall-y2 + 4 * bh

  // Base plate on wall surface (left side, clear of green brick)
  let base-x = wall-x2 + 0.5 * bw
  rect(
    (base-x - 0.45, wall-top), (base-x + 0.45, wall-top + 0.25),
    fill: arm-col.lighten(40%),
    stroke: 0.5pt + arm-col,
    radius: (top-left: 2pt, top-right: 2pt),
  )

  // Joint positions
  let j1 = (base-x, wall-top + 0.25)
  let j2 = (wall-x2 + 3 * bw + 1.0, wall-top + 2.0)
  let wrist-x = new-bx + bw / 2
  let wrist-y = new-by + bh + 0.5
  let j3 = (wrist-x, wrist-y)
  let jr3 = joint-r * 0.7

  // Helper: offset a point toward target by distance d
  let nudge(from, to, d) = {
    let dx = to.at(0) - from.at(0)
    let dy = to.at(1) - from.at(1)
    let len = calc.sqrt(dx * dx + dy * dy)
    (from.at(0) + dx / len * d, from.at(1) + dy / len * d)
  }

  // Upper arm: shoulder → elbow (shortened to avoid joint overlap)
  line(
    nudge(j1, j2, joint-r), nudge(j2, j1, joint-r),
    stroke: (thickness: arm-thick, paint: arm-col.lighten(30%)),
  )

  // Forearm: elbow → wrist (shortened)
  line(
    nudge(j2, j3, joint-r), nudge(j3, j2, jr3),
    stroke: (thickness: arm-thick, paint: arm-col.lighten(50%)),
  )

  // Draw joints on top of arms
  circle(j1, radius: joint-r, fill: arm-col.lighten(60%), stroke: 0.5pt + arm-col)
  circle(j2, radius: joint-r, fill: arm-col.lighten(60%), stroke: 0.5pt + arm-col)
  circle(j3, radius: jr3, fill: arm-col.lighten(60%), stroke: 0.5pt + arm-col)

  // Gripper fingers (start from wrist edge, not center)
  let gs = 0.4   // spread
  let gl = 0.45  // finger length
  let lf = (wrist-x - gs, wrist-y - gl)
  let rf = (wrist-x + gs, wrist-y - gl)
  line(nudge(j3, lf, jr3), lf, stroke: (thickness: 1.2pt, paint: arm-col))
  line(lf, (wrist-x - gs + 0.18, wrist-y - gl - 0.12),
    stroke: (thickness: 1.2pt, paint: arm-col))
  line(nudge(j3, rf, jr3), rf, stroke: (thickness: 1.2pt, paint: arm-col))
  line(rf, (wrist-x + gs - 0.18, wrist-y - gl - 0.12),
    stroke: (thickness: 1.2pt, paint: arm-col))

  // Bob with issue note (to the right, clear of wall and arm)
  content(
    (rx + 4.8, ry - 0.3),
    bob(size: charsize),
  )

  let note-x = rx + 4.1
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
