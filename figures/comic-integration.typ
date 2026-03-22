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
#let col-wall = rgb("#cccccc")     // gray wall background
#let col-good = rgb("#59a14f")     // green — success

#canvas(length: 0.45cm, {
  import draw: *

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

  // Lego wall — uniform blocks, neatly stacked
  let bw = 2.2  // brick width
  let bh = 0.8  // brick height
  let wall-x = lx - 3.3
  let wall-y = ly - 3.5

  // Draw 4 rows of bricks
  for row in range(4) {
    let offset = if calc.rem(row, 2) == 1 { bw / 2 } else { 0 }
    let n-bricks = if calc.rem(row, 2) == 1 { 2 } else { 3 }
    for col in range(n-bricks) {
      let bx = wall-x + offset + col * bw
      let by = wall-y + row * bh
      rect(
        (bx, by), (bx + bw, by + bh),
        fill: brick-colors.at(calc.rem(row * 3 + col, 7)),
        stroke: 0.5pt + white,
        radius: 1pt,
      )
    }
  }

  // Gap in top row — missing brick
  let gap-x = wall-x + bw
  let gap-y = wall-y + 4 * bh
  rect(
    (gap-x, gap-y), (gap-x + bw, gap-y + bh),
    fill: none,
    stroke: (thickness: 0.8pt, paint: luma(180), dash: "dashed"),
    radius: 1pt,
  )
  content(
    (gap-x + bw / 2, gap-y + bh / 2),
    text(5pt, fill: luma(150), [?]),
  )

  // The new piece — wrong shape/size (wider)
  let np-x = lx + 1.5
  let np-y = ly + 2.5
  rect(
    (np-x, np-y), (np-x + bw * 1.4, np-y + bh * 1.3),
    fill: col-new.lighten(30%),
    stroke: 1pt + col-new,
    radius: 1pt,
  )
  content(
    (np-x + bw * 0.7, np-y + bh * 0.65),
    text(5.5pt, fill: col-new.darken(20%), [new rule]),
  )

  // Bob looking frustrated — trying to push it in
  content(
    (lx + 3.5, ly - 1.5),
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

  // Lego wall — complete and uniform
  let wall-x2 = rx - 3.3
  let wall-y2 = ry - 3.5

  for row in range(5) {
    let offset = if calc.rem(row, 2) == 1 { bw / 2 } else { 0 }
    let n-bricks = if calc.rem(row, 2) == 1 { 2 } else { 3 }
    for col in range(n-bricks) {
      let bx = wall-x2 + offset + col * bw
      let by = wall-y2 + row * bh
      let is-new = row == 4 and col == 1
      rect(
        (bx, by), (bx + bw, by + bh),
        fill: if is-new { col-good.lighten(40%) } else { brick-colors.at(calc.rem(row * 3 + col, 7)) },
        stroke: if is-new { 1pt + col-good } else { 0.5pt + white },
        radius: 1pt,
      )
      if is-new {
        content(
          (bx + bw / 2, by + bh / 2),
          text(5pt, fill: col-good.darken(20%), [new rule]),
        )
      }
    }
  }

  // Checkmark above integrated piece
  let ck-x = wall-x2 + bw + bw / 2
  let ck-y = wall-y2 + 5 * bh + 0.3
  content(
    (ck-x, ck-y),
    text(8pt, fill: col-good, [✓]),
  )

  // Bob on left — handing over a note (structured issue)
  content(
    (rx - 4.0, ry - 1.5),
    bob(size: 1.5cm),
  )

  // Note/issue
  let note-x = rx - 2.2
  let note-y = ry - 0.5
  rect(
    (note-x, note-y), (note-x + 1.6, note-y + 1.2),
    fill: white, stroke: 0.5pt + luma(150), radius: 2pt,
  )
  content(
    (note-x + 0.8, note-y + 0.6),
    text(4.5pt, fill: fg, align(center, [GitHub\ issue])),
  )

  // Arrow from note to robot
  line(
    (note-x + 1.7, note-y + 0.6),
    (rx + 0.5, note-y + 0.6),
    stroke: (thickness: 0.8pt, paint: accent),
    mark: (end: "straight", scale: 0.35),
  )

  // Crank (robot) — building
  content(
    (rx + 2.0, ry - 1.5),
    crank(size: 1.5cm),
  )

  // Speech: "integrated & tested"
  content(
    (rx + 2.0, ry + 4.0),
    text(5.5pt, fill: col-good.darken(10%), style: "italic", [integrated \& tested]),
  )
})
