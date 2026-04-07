#import "lib.typ": *
#set page(..fig-page)
#set text(..fig-text)

#import "@preview/cetz:0.4.2": canvas, draw

#canvas(length: 1cm, {
  import draw: *

  let human-color = rgb("#d45d5d")
  let agent-color = accent
  let bar-w = 0.30
  let row-h = 0.58
  let bar-x = -0.15
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
  let arrow-x = -1.2
  let arrow-top = 0.05
  let arrow-bot = -total-h - 0.05
  let arrow-len = arrow-top - arrow-bot
  let shaft-w = 0.18        // half-width of the shaft
  let head-w = 0.35         // half-width of the arrowhead
  let head-h = 0.45         // height of the arrowhead
  let shaft-bot = arrow-bot + head-h  // where shaft meets head

  // Gradient shaft (rounded top)
  let steps = 40
  for i in range(steps) {
    let t0 = i / steps
    let t1 = (i + 1) / steps
    let y0 = arrow-top - t0 * (arrow-top - shaft-bot)
    let y1 = arrow-top - t1 * (arrow-top - shaft-bot)
    let col = human-color.mix((agent-color, t0 * 100%))
    rect(
      (arrow-x - shaft-w, y0), (arrow-x + shaft-w, y1),
      fill: col, stroke: none,
    )
  }

  // Rounded cap at top
  circle(
    (arrow-x, arrow-top),
    radius: shaft-w,
    fill: human-color,
    stroke: none,
  )

  // Filled arrowhead at bottom
  let head-color = agent-color
  line(
    (arrow-x - head-w, shaft-bot),
    (arrow-x, arrow-bot),
    (arrow-x + head-w, shaft-bot),
    close: true,
    fill: head-color,
    stroke: none,
  )

  // Gradient over the arrowhead (triangular region, approximate with rects)
  let head-steps = 12
  for i in range(head-steps) {
    let t0 = i / head-steps
    let t1 = (i + 1) / head-steps
    let y0 = shaft-bot - t0 * head-h
    let y1 = shaft-bot - t1 * head-h
    // width narrows linearly
    let w0 = head-w * (1.0 - t0)
    let w1 = head-w * (1.0 - t1)
    let frac = 0.7 + t0 * 0.3  // already mostly agent-color
    let col = human-color.mix((agent-color, frac * 100%))
    rect(
      (arrow-x - w0, y0), (arrow-x + w0, y1),
      fill: col, stroke: none,
    )
  }

  // Labels on arrow
  content(
    (arrow-x, arrow-top + 0.35),
    text(size: 6.5pt, fill: human-color, weight: "bold")[Human],
    anchor: "south",
  )
  content(
    (arrow-x, arrow-bot - 0.25),
    text(size: 6.5pt, fill: agent-color, weight: "bold")[Agent],
    anchor: "north",
  )

  // ── Horizontal connector lines from arrow to bars ──
  for (i, (label, frac)) in items.enumerate() {
    let y = -i * row-h

    // Thin dashed connector
    line(
      (arrow-x + shaft-w + 0.05, y),
      (bar-x - 0.05, y),
      stroke: (paint: luma(200), thickness: 0.3pt, dash: "dotted"),
    )

    // Horizontal bar
    if frac > 0.01 {
      rect(
        (bar-x, y - bar-w / 2),
        (bar-x + bw * frac, y + bar-w / 2),
        fill: human-color.lighten(35%),
        stroke: none,
      )
    }
    if frac < 0.99 {
      rect(
        (bar-x + bw * frac, y - bar-w / 2),
        (bar-x + bw, y + bar-w / 2),
        fill: agent-color.lighten(35%),
        stroke: none,
      )
    }
    // Border with rounded corners
    rect(
      (bar-x, y - bar-w / 2),
      (bar-x + bw, y + bar-w / 2),
      fill: none,
      stroke: (paint: luma(170), thickness: 0.4pt),
      radius: 1.5pt,
    )

    // Label
    content(
      (bar-x + bw + 0.2, y),
      text(size: 6.5pt, fill: fg)[#label],
      anchor: "west",
    )
  }

  // ── Legend ──
  let ly = -total-h - 0.7
  rect((bar-x, ly - 0.1), (bar-x + 0.25, ly + 0.1), fill: human-color.lighten(35%), stroke: (paint: luma(170), thickness: 0.4pt), radius: 1.5pt)
  content((bar-x + 0.35, ly), text(size: 5.5pt, fill: fg)[Human], anchor: "west")
  rect((bar-x + 1.2, ly - 0.1), (bar-x + 1.45, ly + 0.1), fill: agent-color.lighten(35%), stroke: (paint: luma(170), thickness: 0.4pt), radius: 1.5pt)
  content((bar-x + 1.55, ly), text(size: 5.5pt, fill: fg)[Agent], anchor: "west")
})
