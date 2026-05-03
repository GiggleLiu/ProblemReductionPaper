#import "lib.typ": *
#set page(..fig-page)
#set text(..fig-text)

#import "@preview/cetz:0.4.2": canvas, draw

#canvas(length: 1cm, {
  import draw: *

  let human-color = rgb("#d45d5d")
  let agent-color = accent
  let bar-w = 0.32
  let row-h = 0.42
  let bar-x = 0.0
  let bw = 1.4

  let items = (
    ("Harness engineering", 1.0),
    ("Strategic planning", 1.0),
    ("Merge authorization", 1.0),
    ("Canonical examples", 0.85),
    ("Mathematical verification", 0.8),
    ("Code review", 0.15),
    ("Implementation", 0.05),
    ("Convention enforcement", 0.0),
  )

  let n = items.len()
  let total-h = (n - 1) * row-h

  let pct(frac) = str(calc.round(frac * 100)) + "%"

  // ── Top scale ──
  let scale-y = 0.50
  line(
    (bar-x, scale-y),
    (bar-x + bw, scale-y),
    stroke: (paint: luma(160), thickness: 0.4pt),
  )
  for t in (0.0, 0.5, 1.0) {
    line(
      (bar-x + bw * t, scale-y - 0.04),
      (bar-x + bw * t, scale-y + 0.04),
      stroke: (paint: luma(160), thickness: 0.4pt),
    )
    content(
      (bar-x + bw * t, scale-y + 0.08),
      text(size: 5pt, fill: fg-light)[#pct(t)],
      anchor: "south",
    )
  }
  content(
    (bar-x + bw / 2, scale-y + 0.36),
    text(size: 5.8pt, fill: fg, weight: "bold")[Human share],
    anchor: "south",
  )

  // ── Gradient arrow ──
  let arrow-x = -1.0
  let arrow-top = 0.0
  let arrow-bot = -total-h
  let shaft-w = 0.15
  let head-w = 0.32
  let head-h = 0.40
  let shaft-bot = arrow-bot + head-h

  line(
    (arrow-x - shaft-w, arrow-top),
    (arrow-x + shaft-w, arrow-top),
    (arrow-x + shaft-w, shaft-bot),
    (arrow-x + head-w, shaft-bot),
    (arrow-x, arrow-bot),
    (arrow-x - head-w, shaft-bot),
    (arrow-x - shaft-w, shaft-bot),
    close: true,
    fill: gradient.linear(human-color, agent-color, angle: 90deg),
    stroke: none,
  )

  content(
    (arrow-x, arrow-top + 0.30),
    text(size: 6.5pt, fill: human-color, weight: "bold")[Human],
    anchor: "south",
  )
  content(
    (arrow-x, arrow-bot - 0.20),
    text(size: 6.5pt, fill: agent-color, weight: "bold")[Agent],
    anchor: "north",
  )

  // ── Items ──
  for (i, (label, frac)) in items.enumerate() {
    let y = -i * row-h

    // Connector from arrow to bar
    line(
      (arrow-x + shaft-w + 0.04, y),
      (bar-x - 0.04, y),
      stroke: (paint: luma(200), thickness: 0.3pt, dash: "dotted"),
    )

    // Full-range frame (100% reference)
    rect(
      (bar-x, y - bar-w / 2),
      (bar-x + bw, y + bar-w / 2),
      fill: none,
      stroke: (paint: luma(225), thickness: 0.3pt),
    )

    // Human portion
    if frac > 0.01 {
      rect(
        (bar-x, y - bar-w / 2),
        (bar-x + bw * frac, y + bar-w / 2),
        fill: human-color.lighten(25%),
        stroke: none,
      )
    }
    // Agent portion
    if frac < 0.99 {
      rect(
        (bar-x + bw * frac, y - bar-w / 2),
        (bar-x + bw, y + bar-w / 2),
        fill: agent-color.lighten(25%),
        stroke: none,
      )
    }

    // Percentage at end of bar
    content(
      (bar-x + bw + 0.08, y),
      text(size: 5.8pt, fill: fg-light)[#pct(frac)],
      anchor: "west",
    )

    // Category label
    content(
      (bar-x + bw + 0.55, y),
      text(size: 6.5pt, fill: fg)[#label],
      anchor: "west",
    )
  }

  // ── Legend ──
  let ly = -total-h - 0.55
  rect(
    (bar-x, ly - 0.09),
    (bar-x + 0.22, ly + 0.09),
    fill: human-color.lighten(25%),
    stroke: none,
  )
  content((bar-x + 0.28, ly), text(size: 5.5pt, fill: fg)[Human], anchor: "west")
  rect(
    (bar-x + 0.78, ly - 0.09),
    (bar-x + 1.00, ly + 0.09),
    fill: agent-color.lighten(25%),
    stroke: none,
  )
  content((bar-x + 1.06, ly), text(size: 5.5pt, fill: fg)[Agent], anchor: "west")
})
