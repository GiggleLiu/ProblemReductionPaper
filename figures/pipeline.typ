#import "lib.typ": *

#set page(..fig-page)
#set text(..fig-text)

// Role colors
#let col-human = rgb("#f28e2b")   // orange — human
#let col-agent = accent            // steel blue — agent

#canvas(length: 0.55cm, {
  import draw: *

  let box-w = 3.0
  let box-h = 0.9
  let gap-x = 1.2
  let ann-dy = 0.9  // annotation offset below box

  // Stage data: (label, color, annotation)
  let stages = (
    ("Propose", col-human, [Domain expert files\ structured issue]),
    ("Validate", col-agent, [Four checks: useful,\ non-trivial, correct, complete]),
    ("Implement", col-agent, [Issue → PR via\ skill checklist]),
    ("Review", col-agent, [Parallel sub-agents\ + feature test]),
    ("Merge", col-human, [Maintainer reviews\ verdict and merges]),
    ("Verify", col-human, [Domain expert checks\ intent preserved]),
  )

  let n = stages.len()

  for (i, (label, col, ann)) in stages.enumerate() {
    let cx = i * (box-w + gap-x)
    let id = "s" + str(i)

    // Box
    rect(
      (cx - box-w / 2, -box-h / 2),
      (cx + box-w / 2, box-h / 2),
      radius: 3pt,
      fill: col.lighten(85%),
      stroke: 0.9pt + col,
      name: id,
    )

    // Stage label
    content(id, text(7.5pt, weight: "bold", fill: col.darken(20%), label))

    // Annotation below
    content(
      (cx, -box-h / 2 - ann-dy),
      text(6pt, fill: fg-light, align(center, ann)),
    )

    // Arrow to next
    if i < n - 1 {
      line(
        (cx + box-w / 2 + 0.05, 0),
        (cx + box-w / 2 + gap-x - 0.05, 0),
        stroke: (thickness: 1pt, paint: luma(120)),
        mark: (end: "straight", scale: 0.35),
      )
    }
  }

  // Legend
  let ly = -box-h / 2 - ann-dy - 1.0
  let lx = 0 * (box-w + gap-x) - box-w / 2
  rect((lx, ly - 0.18), (lx + 0.5, ly + 0.18), fill: col-human.lighten(85%), stroke: 0.8pt + col-human, radius: 2pt)
  content((lx + 0.65, ly), anchor: "west", text(6pt, [Human]))
  rect((lx + 2.5, ly - 0.18), (lx + 3.0, ly + 0.18), fill: col-agent.lighten(85%), stroke: 0.8pt + col-agent, radius: 2pt)
  content((lx + 3.15, ly), anchor: "west", text(6pt, [Agent]))
})
