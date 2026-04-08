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
    ("Harness engineering (skills, specs, tools)", 1.0),
    ("Strategic planning (priorities, roadmap)", 1.0),
    ("Merge authorization (security, final approval)", 1.0),
    ("Canonical examples (ground truth instances)", 0.85),
    ("Mathematical verification (correctness, proofs)", 0.8),
    ("Code review (structure, correctness, feature tests)", 0.15),
    ("Implementation (code, tests, documentation)", 0.05),
    ("Convention enforcement (formatting, layout, checks)", 0.0),
  )

  let n = items.len()
  let total-h = (n - 1) * row-h

  // ── Gradient arrow (single path) ──
  let arrow-x = -1.0
  let arrow-top = 0.0
  let arrow-bot = -total-h
  let shaft-w = 0.15
  let head-w = 0.32
  let head-h = 0.40
  let shaft-bot = arrow-bot + head-h

  // One closed path: right side down, tip, left side up
  line(
    (arrow-x - shaft-w, arrow-top),   // top-left
    (arrow-x + shaft-w, arrow-top),   // top-right
    (arrow-x + shaft-w, shaft-bot),   // shaft bottom-right
    (arrow-x + head-w, shaft-bot),    // head right wing
    (arrow-x, arrow-bot),             // tip
    (arrow-x - head-w, shaft-bot),    // head left wing
    (arrow-x - shaft-w, shaft-bot),   // shaft bottom-left
    close: true,
    fill: gradient.linear(human-color, agent-color, angle: 90deg),
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
