#import "lib.typ": *

#set page(..fig-page)
#set text(..fig-text)

// ── Layer data: (number, name, novel?) ──
#let layers = (
  (1, "Issue review",                 false),
  (2, "Compile-time type checks",     false),
  (3, "Unit tests",                   false),
  (4, "Round-trip tests",             true),
  (5, "Agentic feature tests",        true),
  (6, "Manual verification",          false),
)

#canvas(length: 1cm, {
  import draw: *

  // ── Layout ────────────────────────────────────────────
  let bw = 6.4
  let bh = 0.86
  let gap = 0.30
  let cap-w = 4.6
  let cap-h = 0.78

  // x for the left "rail" (vertical guide visualising the pipeline)
  let rail-x = -bw / 2 - 0.65

  let n = layers.len()
  let total-stack-h = n * bh + (n - 1) * gap

  let stack-top-y = 0
  let stack-bot-y = stack-top-y - total-stack-h

  // ── Top cap: input ────────────────────────────────────
  let cap-top-y = stack-top-y + 0.65
  rect(
    (-cap-w / 2, cap-top-y),
    ( cap-w / 2, cap-top-y + cap-h),
    radius: cap-h / 2,
    fill: white,
    stroke: (thickness: 1pt, paint: fg),
    name: "input",
  )
  content(
    "input", anchor: "center",
    text(8.5pt, weight: "bold", fill: fg)[Candidate contribution],
  )

  // ── Left rail: thin vertical line behind the blocks ──
  // creates a polished "pipeline track" that the blocks ride on
  line(
    (rail-x, cap-top-y + cap-h / 2),
    (rail-x, stack-bot-y - 0.7 - cap-h / 2),
    stroke: (thickness: 0.8pt, paint: luma(220)),
  )
  // small dot at top of rail
  circle((rail-x, cap-top-y + cap-h / 2), radius: 0.06,
    fill: fg, stroke: none)

  // ── Six layer blocks ─────────────────────────────────
  for i in range(n) {
    let (num, name, is-novel) = layers.at(i)

    let y-top = stack-top-y - i * (bh + gap)
    let y-bot = y-top - bh
    let y-mid = (y-top + y-bot) / 2

    let stroke-c = if is-novel { accent } else { border }
    let fill-c   = if is-novel { accent.lighten(92%) } else { white }
    let stroke-w = if is-novel { 1.4pt } else { 0.9pt }
    let txt-c    = if is-novel { accent.darken(20%) } else { fg }

    // Connector tick from rail into block
    line(
      (rail-x, y-mid),
      (-bw / 2 - 0.04, y-mid),
      stroke: (thickness: 0.8pt, paint: if is-novel { accent } else { luma(180) }),
    )
    // Rail bullet (filled disc) at this layer's height
    circle(
      (rail-x, y-mid),
      radius: if is-novel { 0.13 } else { 0.10 },
      fill: if is-novel { accent } else { fg },
      stroke: none,
    )

    // Main block
    rect(
      (-bw / 2, y-bot),
      ( bw / 2, y-top),
      radius: 4pt,
      fill: fill-c,
      stroke: (thickness: stroke-w, paint: stroke-c),
      name: "L" + str(i),
    )

    // Numbered badge (circle) on the left inside the block
    let badge-r = 0.26
    let badge-x = -bw / 2 + 0.45
    circle(
      (badge-x, y-mid), radius: badge-r,
      fill: if is-novel { accent } else { luma(235) },
      stroke: (thickness: 0.8pt, paint: if is-novel { accent } else { border }),
    )
    content(
      (badge-x, y-mid), anchor: "center",
      text(8pt, weight: "bold",
        fill: if is-novel { white } else { fg },
        font: "Helvetica", str(num)),
    )

    // Layer name
    content(
      (badge-x + badge-r + 0.25, y-mid), anchor: "west",
      text(9.5pt, weight: "bold", fill: txt-c, name),
    )

    // Novel-layer accent stripe on the right side, inside the block
    if is-novel {
      // thin stripe
      rect(
        (bw / 2 - 0.18, y-bot + 0.10),
        (bw / 2 - 0.06, y-top - 0.10),
        fill: accent, stroke: none,
      )
      // ★ glyph next to the stripe
      content(
        (bw / 2 - 0.45, y-mid), anchor: "east",
        text(8pt, weight: "bold", fill: accent, sym.star),
      )
    }

    // arrow from this block to the next
    if i < n - 1 {
      let next-top = y-bot - gap
      line(
        (0, y-bot - 0.04),
        (0, next-top + 0.04),
        stroke: (thickness: 0.7pt, paint: luma(170)),
        mark: (end: "straight", scale: 0.3),
      )
    }
  }

  // ── Arrow from input cap into stack ──────────────────
  line(
    (0, cap-top-y - 0.04),
    (0, stack-top-y - 0.04),
    stroke: (thickness: 1pt, paint: fg),
    mark: (end: "straight", scale: 0.4),
  )

  // ── Bottom cap: output ───────────────────────────────
  let cap-bot-y = stack-bot-y - 0.7
  rect(
    (-cap-w / 2, cap-bot-y - cap-h),
    ( cap-w / 2, cap-bot-y),
    radius: cap-h / 2,
    fill: accent.lighten(88%),
    stroke: (thickness: 1.3pt, paint: accent),
    name: "output",
  )
  content(
    "output", anchor: "center",
    text(8.5pt, weight: "bold", fill: accent.darken(20%))[Verified library entry],
  )

  // arrow from last block into output
  line(
    (0, stack-bot-y - 0.04),
    (0, cap-bot-y + 0.04),
    stroke: (thickness: 1pt, paint: accent),
    mark: (end: "straight", scale: 0.4),
  )

  // bottom rail bullet
  circle((rail-x, cap-bot-y - cap-h / 2), radius: 0.08,
    fill: accent, stroke: none)
})
