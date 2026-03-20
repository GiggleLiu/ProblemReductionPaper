#import "lib.typ": *

#set page(..fig-page)
#set text(..fig-text)

// Three roles — color on lines only, not nodes
#let col-human = rgb("#f28e2b")   // orange — human decisions
#let col-impl = accent             // steel blue — implementation agent
#let col-review = rgb("#76b7b2")   // teal — review agent
#let col-fail = rgb("#e15759")     // red — failure path

#let card-w = 3.2
#let card-h = 0.7
#let gap-y = 1.0

#canvas(length: 0.55cm, {
  import draw: *

  // --- Helpers ---
  // All cards neutral — roles conveyed by arrow color
  let board-card(x, y, label, id) = {
    rect(
      (x - card-w / 2, y - card-h / 2),
      (x + card-w / 2, y + card-h / 2),
      radius: 3pt, fill: fill-light, stroke: stroke-box, name: id,
    )
    content(id, text(7pt, weight: "bold", fill: fg, label))
  }

  let varrow(from-y, to-y, col, cx) = {
    line(
      (cx, from-y - card-h / 2), (cx, to-y + card-h / 2 + 0.05),
      stroke: (thickness: 1.2pt, paint: col),
      mark: (end: "straight", scale: 0.4),
    )
  }

  let label-right(from-y, to-y, col, txt, cx) = {
    content(
      (cx + card-w / 2 + 0.2, (from-y + to-y) / 2), anchor: "west",
      text(6.5pt, fill: col, txt),
    )
  }

  let label-left(from-y, to-y, col, txt, cx) = {
    content(
      (cx - card-w / 2 - 0.2, (from-y + to-y) / 2), anchor: "east",
      text(6.5pt, fill: col, txt),
    )
  }

  let cx = 0
  let y0 = 0

  // --- Entry: Domain Expert → Backlog ---
  let entry-x = cx - card-w / 2 - 2.0
  content(
    (entry-x, y0), anchor: "center",
    text(6.5pt, fill: col-human.darken(10%), weight: "bold",
      align(center, [Domain\ Expert])),
  )
  line(
    (entry-x + 0.85, y0), (cx - card-w / 2 - 0.05, y0),
    stroke: (thickness: 1pt, paint: col-human),
    mark: (end: "straight", scale: 0.35),
  )

  // 1. Backlog
  board-card(cx, y0, "Backlog", "backlog")

  // Backlog → Ready (Maintainer)
  let y1 = y0 - gap-y
  varrow(y0, y1, col-human, cx)
  label-right(y0, y1, col-human, [Maintainer triages], cx)

  // 2. Ready
  board-card(cx, y1, "Ready", "ready")

  // Ready → In Progress (Impl Agent)
  let y2 = y1 - gap-y
  varrow(y1, y2, col-impl, cx)
  label-right(y1, y2, col-impl, [picks issue], cx)

  // 3. In Progress
  board-card(cx, y2, "In Progress", "inprog")

  // In Progress → Review Pool (Impl Agent)
  let y3 = y2 - gap-y
  varrow(y2, y3, col-impl, cx)
  label-right(y2, y3, col-impl, [creates PR], cx)

  // 4. Review Pool
  board-card(cx, y3, "Review Pool", "revpool")

  // Review Pool → Under Review (Review Agent)
  let y4 = y3 - gap-y
  varrow(y3, y4, col-review, cx)
  label-right(y3, y4, col-review, [parallel review], cx)

  // 5. Under Review
  board-card(cx, y4, "Under Review", "underrev")

  // Under Review → Final Review (Review Agent)
  let y5 = y4 - gap-y
  varrow(y4, y5, col-review, cx)
  label-right(y4, y5, col-review, [posts verdict], cx)

  // 6. Final Review
  board-card(cx, y5, "Final Review", "finalrev")

  // Final Review → Done (Maintainer)
  let y6 = y5 - gap-y
  varrow(y5, y6, col-human, cx)
  label-left(y5, y6, col-human, [Maintainer merges], cx)

  // 7. Done
  board-card(cx, y6, "Done", "done")

  // --- On Hold: receives arrows from In Progress and Final Review ---
  let oh-w = 2.0
  let oh-x = cx + card-w / 2 + 3.2
  let oh-y = (y2 + y5) / 2
  board-card(oh-x, oh-y, "On Hold", "onhold")

  // Arrow from In Progress → On Hold
  line(
    (cx + card-w / 2, y2),
    (oh-x - oh-w / 2 + 0.2, oh-y + card-h / 2 + 0.05),
    stroke: (thickness: 1pt, paint: col-fail),
    mark: (end: "straight", scale: 0.35),
  )

  // Arrow from Final Review → On Hold
  line(
    (cx + card-w / 2, y5),
    (oh-x - oh-w / 2 + 0.2, oh-y - card-h / 2 - 0.05),
    stroke: (thickness: 1pt, paint: col-fail),
    mark: (end: "straight", scale: 0.35),
  )

  // --- Implementation Agent bracket ---
  let bx = cx - card-w / 2 - 0.5
  let impl-top = y1 - card-h / 2 - 0.05
  let impl-bot = y3 + card-h / 2 + 0.05
  line(
    (bx + 0.12, impl-top), (bx, impl-top),
    (bx, impl-bot), (bx + 0.12, impl-bot),
    stroke: (thickness: 0.8pt, paint: col-impl),
  )
  content(
    (bx - 0.1, (impl-top + impl-bot) / 2), anchor: "east",
    text(6pt, fill: col-impl, weight: "bold",
      align(center, [Impl.\ Agent])),
  )

  // --- Review Agent bracket ---
  let rev-top = y3 - card-h / 2 - 0.05
  let rev-bot = y5 + card-h / 2 + 0.05
  line(
    (bx + 0.12, rev-top), (bx, rev-top),
    (bx, rev-bot), (bx + 0.12, rev-bot),
    stroke: (thickness: 0.8pt, paint: col-review),
  )
  content(
    (bx - 0.1, (rev-top + rev-bot) / 2), anchor: "east",
    text(6pt, fill: col-review, weight: "bold",
      align(center, [Review\ Agent])),
  )

  // --- Legend ---
  let ly = y6 - card-h / 2 - 0.7
  let lx = cx - 4.5
  line((lx, ly), (lx + 0.5, ly), stroke: 1.2pt + col-human)
  content((lx + 0.65, ly), anchor: "west", text(6pt, [Human]))
  line((lx + 2.0, ly), (lx + 2.5, ly), stroke: 1.2pt + col-impl)
  content((lx + 2.65, ly), anchor: "west", text(6pt, [Impl. agent]))
  line((lx + 5.0, ly), (lx + 5.5, ly), stroke: 1.2pt + col-review)
  content((lx + 5.65, ly), anchor: "west", text(6pt, [Review agent]))
})
