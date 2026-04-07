#import "lib.typ": *
#set page(..fig-page)
#set text(..fig-text)

#import "@preview/cetz:0.4.2": canvas, draw

#canvas(length: 1cm, {
  import draw: *

  let human-color = rgb("#d45d5d")
  let agent-color = accent
  let bar-w = 0.35
  let row-h = 0.65
  let label-x = 4.0
  let bar-x = -0.15

  let items = (
    // (label, fraction-human 0..1)
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
  let total-h = n * row-h

  // gradient arrow on the left
  let arrow-x = -1.6
  let arrow-top = 0.15
  let arrow-bot = -total-h + 0.5

  // Draw gradient bar
  let steps = 30
  for i in range(steps) {
    let t0 = i / steps
    let t1 = (i + 1) / steps
    let y0 = arrow-top - t0 * (arrow-top - arrow-bot)
    let y1 = arrow-top - t1 * (arrow-top - arrow-bot)
    let col = human-color.mix((agent-color, t0 * 100%))
    rect(
      (arrow-x - 0.12, y0), (arrow-x + 0.12, y1),
      fill: col, stroke: none,
    )
  }

  // Arrow head at bottom
  line(
    (arrow-x, arrow-bot - 0.15),
    (arrow-x - 0.15, arrow-bot),
    stroke: (paint: agent-color, thickness: 1.2pt),
  )
  line(
    (arrow-x, arrow-bot - 0.15),
    (arrow-x + 0.15, arrow-bot),
    stroke: (paint: agent-color, thickness: 1.2pt),
  )

  // Arrow labels
  content(
    (arrow-x, arrow-top + 0.35),
    text(size: 6pt, fill: human-color, weight: "bold")[Human],
    anchor: "south",
  )
  content(
    (arrow-x, arrow-bot - 0.35),
    text(size: 6pt, fill: agent-color, weight: "bold")[Agent],
    anchor: "north",
  )

  // Items
  for (i, (label, frac)) in items.enumerate() {
    let y = -i * row-h

    // Horizontal bar showing human/agent split
    let bw = 1.0
    if frac > 0.01 {
      rect(
        (bar-x, y - bar-w / 2),
        (bar-x + bw * frac, y + bar-w / 2),
        fill: human-color.lighten(40%),
        stroke: none,
      )
    }
    if frac < 0.99 {
      rect(
        (bar-x + bw * frac, y - bar-w / 2),
        (bar-x + bw, y + bar-w / 2),
        fill: agent-color.lighten(40%),
        stroke: none,
      )
    }
    // Border
    rect(
      (bar-x, y - bar-w / 2),
      (bar-x + bw, y + bar-w / 2),
      fill: none,
      stroke: (paint: luma(180), thickness: 0.4pt),
    )

    // Label
    content(
      (bar-x + bw + 0.2, y),
      text(size: 6.5pt, fill: fg)[#label],
      anchor: "west",
    )
  }

  // Legend
  let ly = -total-h - 0.3
  rect((bar-x, ly - 0.12), (bar-x + 0.3, ly + 0.12), fill: human-color.lighten(40%), stroke: (paint: luma(180), thickness: 0.4pt))
  content((bar-x + 0.4, ly), text(size: 5.5pt, fill: fg)[Human], anchor: "west")
  rect((bar-x + 1.3, ly - 0.12), (bar-x + 1.6, ly + 0.12), fill: agent-color.lighten(40%), stroke: (paint: luma(180), thickness: 0.4pt))
  content((bar-x + 1.7, ly), text(size: 5.5pt, fill: fg)[Agent], anchor: "west")
})
