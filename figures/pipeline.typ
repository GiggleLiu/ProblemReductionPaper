#import "lib.typ": *
#import "pixel-family/lib.typ": bob, grace, crank, sentinel

#set page(..fig-page)
#set text(..fig-text)

// Three roles — color on lines only, not nodes
#let col-human = rgb("#f28e2b")   // orange — human decisions
#let col-impl = accent             // steel blue — implementation agent
#let col-review = rgb("#76b7b2")   // teal — review agent
#let col-fail = rgb("#e15759")     // red — failure path

#let card-w = 3
#let card-h = 0.7
#let gap-x = 1.0
#let char-size = 0.7cm

#canvas(length: 0.55cm, {
  import draw: *

  // --- Helpers ---
  let board-card(x, y, label, id) = {
    rect(
      (x - card-w / 2, y - card-h / 2),
      (x + card-w / 2, y + card-h / 2),
      radius: 3pt, fill: fill-light, stroke: 0.8pt + border, name: id,
    )
    content(id, text(7pt, fill: fg, label))
  }

  let harrow(from-x, to-x, col, cy) = {
    line(
      (from-x + card-w / 2, cy), (to-x - card-w / 2 - 0.05, cy),
      stroke: (thickness: 1.2pt, paint: col),
      mark: (end: "straight", scale: 0.4),
    )
  }

  let label-above(from-x, to-x, col, txt, cy) = {
    content(
      ((from-x + to-x) / 2, cy + card-h / 2 + 0.25), anchor: "south",
      text(6.5pt, fill: col, txt),
    )
  }

  let label-below(from-x, to-x, col, txt, cy) = {
    content(
      ((from-x + to-x) / 2, cy - card-h / 2 - 0.25), anchor: "north",
      text(6.5pt, fill: col, txt),
    )
  }

  let cy = 0
  let x0 = 0

  // --- Entry: Domain Expert → Backlog ---
  let entry-y = cy + card-h / 2 + 1.5
  content(
    (x0 + 0.8, entry-y), anchor: "west",
    text(6.5pt, fill: col-human.darken(10%),
      align(center, [Domain Expert\ (`propose`)])),
  )
  content(
    (x0 - 0.8, entry-y), anchor: "east",
    bob(size: char-size),
  )
  line(
    (x0, entry-y - 0.5), (x0, cy + card-h / 2 + 0.05),
    stroke: (thickness: 1pt, paint: col-human),
    mark: (end: "straight", scale: 0.35),
  )

  // 1. Backlog
  board-card(x0, cy, "Backlog", "backlog")

  // Backlog → Ready (Maintainer)
  let x1 = x0 + card-w + gap-x
  harrow(x0, x1, col-human, cy)
  content(
    ((x0 + x1) / 2 + 1.0, cy - card-h / 2 - 0.55), anchor: "west",
    text(6.5pt, fill: col-human, [Maintainer triages\ (`fix-issue`)]),
  )
  content(
    ((x0 + x1) / 2 - 1.0, cy - card-h / 2 - 0.55), anchor: "east",
    grace(size: char-size),
  )

  // 2. Ready
  board-card(x1, cy, "Ready", "ready")

  // Ready → In Progress (Impl Agent)
  let x2 = x1 + card-w + gap-x
  harrow(x1, x2, col-impl, cy)
  label-above(x1, x2, black, [picks issue], cy)

  // 3. In Progress
  board-card(x2, cy, "In Progress", "inprog")

  // In Progress → Review Pool (Impl Agent)
  let x3 = x2 + card-w + gap-x
  harrow(x2, x3, col-impl, cy)
  label-above(x2, x3, black, [creates PR], cy)

  // 4. Review Pool
  board-card(x3, cy, "Review Pool", "revpool")

  // Review Pool → Under Review (Review Agent)
  let x4 = x3 + card-w + gap-x
  harrow(x3, x4, col-review, cy)

  // 5. Under Review
  board-card(x4, cy, "Under Review", "underrev")

  // Under Review → Final Review (Review Agent)
  let x5 = x4 + card-w + gap-x
  harrow(x4, x5, col-review, cy)
  label-above(x4, x5, black, [posts verdict], cy)

  // 6. Final Review
  board-card(x5, cy, "Final Review", "finalrev")

  // Final Review → Done (Maintainer)
  let x6 = x5 + card-w + gap-x
  harrow(x5, x6, col-human, cy)
  content(
    ((x5 + x6) / 2 + 1.0, cy - card-h / 2 - 0.55), anchor: "west",
    text(6.5pt, fill: col-human, [Maintainer merges\ (`final-review`)]),
  )
  content(
    ((x5 + x6) / 2 - 1.0, cy - card-h / 2 - 0.55), anchor: "east",
    grace(size: char-size),
  )

  // 7. Done
  board-card(x6, cy, "Done", "done")

  // L-shaped arrows placeholder
  let bend-y = cy - card-h / 2 - 2.0

  // --- Implementation Agent bracket ---
  let by = cy - card-h / 2 - 0.5
  let impl-left = x1 + card-w / 2 + 0.05
  let impl-right = x3 - card-w / 2 - 0.05
  line(
    (impl-left, by + 0.12), (impl-left, by),
    (impl-right, by), (impl-right, by + 0.12),
    stroke: (thickness: 0.8pt, paint: col-impl),
  )
  content(
    ((impl-left + impl-right) / 2 + 0.8, by - 0.6), anchor: "west",
    text(6pt, fill: col-impl, [Impl. Agent\ (`run-pipeline`)]),
  )
  content(
    ((impl-left + impl-right) / 2 - 0.8, by - 0.6), anchor: "east",
    crank(size: char-size),
  )

  // --- Review Agent bracket ---
  let rev-left = x3 + card-w / 2 + 0.05
  let rev-right = x5 - card-w / 2 - 0.05
  line(
    (rev-left, by + 0.12), (rev-left, by),
    (rev-right, by), (rev-right, by + 0.12),
    stroke: (thickness: 0.8pt, paint: col-review),
  )
  content(
    ((rev-left + rev-right) / 2 + 0.8, by - 0.6), anchor: "west",
    text(6pt, fill: col-review, [Review Agent\ (`review-pipeline`)]),
  )
  content(
    ((rev-left + rev-right) / 2 - 0.8, by - 0.6), anchor: "east",
    sentinel(size: char-size),
  )
})
