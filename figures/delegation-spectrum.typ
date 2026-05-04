#import "lib.typ": *
#set page(..fig-page)
#set text(..fig-text)

#import "@preview/cetz:0.4.2": canvas, draw

#canvas(length: 1cm, {
  import draw: *

  let human-color = rgb("#f28e2b")
  let human-fill = white
  let human-stroke = human-color
  let agent-fill = fill-accent
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

  // ── Direction cue, styled like the thin arrows in the pipeline diagram ──
  let arrow-x = -1.0
  let arrow-top = 0.0
  let arrow-bot = -total-h

  line(
    (arrow-x, arrow-top - 0.05),
    (arrow-x, arrow-bot + 0.05),
    stroke: (paint: agent-color, thickness: 1.0pt),
    mark: (end: "straight", scale: 0.38),
  )

  content(
    (arrow-x, arrow-top + 0.30),
    text(size: 6.5pt, fill: human-color.darken(15%), weight: "bold")[Human],
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
      (arrow-x + 0.08, y),
      (bar-x - 0.04, y),
      stroke: (paint: luma(145), thickness: 0.35pt, dash: "dotted"),
    )

    // Full-range frame (100% reference)
    rect(
      (bar-x, y - bar-w / 2),
      (bar-x + bw, y + bar-w / 2),
      radius: 2pt,
      fill: none,
      stroke: (paint: luma(215), thickness: 0.35pt),
    )

    // Human portion
    if frac > 0.01 {
      rect(
        (bar-x, y - bar-w / 2),
        (bar-x + bw * frac, y + bar-w / 2),
        fill: human-fill,
        stroke: (paint: human-stroke.lighten(15%), thickness: 0.35pt),
      )
    }
    // Agent portion
    if frac < 0.99 {
      rect(
        (bar-x + bw * frac, y - bar-w / 2),
        (bar-x + bw, y + bar-w / 2),
        fill: agent-fill,
        stroke: (paint: accent, thickness: 0.35pt),
      )
    }

    // Category label
    content(
      (bar-x + bw + 0.15, y),
      text(size: 6.5pt, fill: fg)[#label],
      anchor: "west",
    )
  }

  // ── Legend ──
  let ly = -total-h - 0.55
  rect(
    (bar-x, ly - 0.09),
    (bar-x + 0.22, ly + 0.09),
    fill: human-fill,
    stroke: (paint: human-stroke.lighten(15%), thickness: 0.35pt),
  )
  content((bar-x + 0.28, ly), text(size: 5.5pt, fill: fg)[Human], anchor: "west")
  rect(
    (bar-x + 1.10, ly - 0.09),
    (bar-x + 1.32, ly + 0.09),
    fill: agent-fill,
    stroke: (paint: accent, thickness: 0.35pt),
  )
  content((bar-x + 1.38, ly), text(size: 5.5pt, fill: fg)[Agent], anchor: "west")
})
