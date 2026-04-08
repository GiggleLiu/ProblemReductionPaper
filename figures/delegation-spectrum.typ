#import "lib.typ": *
#set page(..fig-page)
#set text(..fig-text)

#import "@preview/cetz:0.4.2": canvas, draw

#canvas(length: 1cm, {
  import draw: *

  let human-color = rgb("#d45d5d")
  let agent-color = accent
  let bar-w = 0.28
  let row-h = 0.56
  let bar-x = 0.0
  let bw = 1.0

  let items = (
    ("Harness engineering (skills, specs, tool design)", 1.0),
    ("Strategic decisions (which reduction to pursue)", 1.0),
    ("Mathematical content (correctness argument)", 0.9),
    ("Canonical examples (worked instances)", 0.85),
    ("Merge authorization (security, final approval)", 0.8),
    ("Quality checks (symbols, metrics, references)", 0.2),
    ("Topology analysis (detect graph gaps)", 0.15),
    ("Code review (structure, style, feature tests)", 0.1),
    ("Implementation (forward/inverse maps, tests)", 0.0),
    ("Mechanical fixes (formatting, naming, layout)", 0.0),
  )

  let n = items.len()
  let total-h = (n - 1) * row-h

  // ── Gradient arrow on the left ──
  let arrow-x = -1.0
  let arrow-top = 0.0
  let arrow-bot = -total-h
  let shaft-w = 0.15
  let head-w = 0.32
  let head-h = 0.40
  let shaft-bot = arrow-bot + head-h

  // Shaft with native gradient fill
  rect(
    (arrow-x - shaft-w, shaft-bot),
    (arrow-x + shaft-w, arrow-top),
    fill: gradient.linear(agent-color, human-color, angle: 90deg),
    stroke: none,
    radius: (top: 3pt),
  )

  // Arrowhead with gradient fill
  line(
    (arrow-x - head-w, shaft-bot),
    (arrow-x, arrow-bot),
    (arrow-x + head-w, shaft-bot),
    close: true,
    fill: gradient.linear(agent-color, agent-color.mix((human-color, 30%)), angle: 90deg),
    stroke: none,
  )

  // Labels
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

    // Dotted connector from arrow to bar
    line(
      (arrow-x + shaft-w + 0.04, y),
      (bar-x - 0.04, y),
      stroke: (paint: luma(200), thickness: 0.3pt, dash: "dotted"),
    )

    // Human portion
    if frac > 0.01 {
      rect(
        (bar-x, y - bar-w / 2),
        (bar-x + bw * frac, y + bar-w / 2),
        fill: human-color.lighten(35%),
        stroke: none,
        radius: if frac > 0.99 { 2pt } else { (left: 2pt) },
      )
    }
    // Agent portion
    if frac < 0.99 {
      rect(
        (bar-x + bw * frac, y - bar-w / 2),
        (bar-x + bw, y + bar-w / 2),
        fill: agent-color.lighten(35%),
        stroke: none,
        radius: if frac < 0.01 { 2pt } else { (right: 2pt) },
      )
    }

    // Label
    content(
      (bar-x + bw + 0.15, y),
      text(size: 6.5pt, fill: fg)[#label],
      anchor: "west",
    )
  }

  // ── Legend ──
  let ly = -total-h - 0.55
  rect((bar-x, ly - 0.09), (bar-x + 0.22, ly + 0.09), fill: human-color.lighten(35%), stroke: none, radius: 1.5pt)
  content((bar-x + 0.30, ly), text(size: 5.5pt, fill: fg)[Human], anchor: "west")
  rect((bar-x + 1.1, ly - 0.09), (bar-x + 1.32, ly + 0.09), fill: agent-color.lighten(35%), stroke: none, radius: 1.5pt)
  content((bar-x + 1.40, ly), text(size: 5.5pt, fill: fg)[Agent], anchor: "west")
})
