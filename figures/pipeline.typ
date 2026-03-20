#import "lib.typ": *

#set page(..fig-page)
#set text(..fig-text)

// Two-color scheme: human = orange, agent = accent blue
#let col-human = rgb("#f28e2b")
#let col-agent = accent
#let col-bg-human = col-human.lighten(85%)
#let col-bg-agent = accent-light
#let col-fail = rgb("#e15759")

#let card-w = 2.6
#let card-h = 0.55
#let gap-y = 0.95

#canvas(length: 0.55cm, {
  import draw: *

  // --- Helpers ---
  let board-card(x, y, label, bg, stroke-col, id) = {
    rect(
      (x - card-w / 2, y - card-h / 2),
      (x + card-w / 2, y + card-h / 2),
      radius: 3pt, fill: bg, stroke: 1pt + stroke-col, name: id,
    )
    content(id, text(7.5pt, weight: "bold", fill: stroke-col.darken(15%), label))
  }

  let arrow(from-y, to-y, col, cx) = {
    line(
      (cx, from-y - card-h / 2), (cx, to-y + card-h / 2 + 0.05),
      stroke: (thickness: 1.2pt, paint: col),
      mark: (end: "straight", scale: 0.4),
    )
  }

  let label-right(from-y, to-y, col, txt, cx) = {
    content(
      (cx + card-w / 2 + 0.15, (from-y + to-y) / 2), anchor: "west",
      text(6.5pt, fill: col, txt),
    )
  }

  let cx = 0
  let y0 = 0

  // --- Entry: Domain Expert files issue → Backlog ---
  let entry-x = cx - card-w / 2 - 1.6
  content(
    (entry-x, y0), anchor: "center",
    text(6.5pt, fill: col-human.darken(10%), weight: "bold",
      align(center, [Domain\ Expert])),
  )
  line(
    (entry-x + 0.7, y0), (cx - card-w / 2 - 0.05, y0),
    stroke: (thickness: 1pt, paint: col-human),
    mark: (end: "straight", scale: 0.35),
  )
  content(
    ((entry-x + 0.7 + cx - card-w / 2 - 0.05) / 2, y0 + 0.22),
    anchor: "south",
    text(5.5pt, fill: col-human, style: "italic", [files issue]),
  )

  // 1. Backlog
  board-card(cx, y0, "Backlog", fill-light, fg-light, "backlog")

  // Backlog → Ready (Maintainer)
  let y1 = y0 - gap-y
  arrow(y0, y1, col-human, cx)
  label-right(y0, y1, col-human, [Maintainer triages], cx)

  // 2. Ready
  board-card(cx, y1, "Ready", col-bg-human, col-human, "ready")

  // Ready → In Progress (Agent picks)
  let y2 = y1 - gap-y
  arrow(y1, y2, col-agent, cx)
  label-right(y1, y2, col-agent, [picks issue], cx)

  // 3. In Progress
  board-card(cx, y2, "In Progress", col-bg-agent, col-agent, "inprog")

  // In Progress → Review Pool (Agent creates PR)
  let y3 = y2 - gap-y
  arrow(y2, y3, col-agent, cx)
  label-right(y2, y3, col-agent, [creates PR], cx)

  // 4. Review Pool
  board-card(cx, y3, "Review Pool", col-bg-agent, col-agent, "revpool")

  // Review Pool → Under Review (Agent reviews)
  let y4 = y3 - gap-y
  arrow(y3, y4, col-agent, cx)
  label-right(y3, y4, col-agent, [parallel review], cx)

  // 5. Under Review
  board-card(cx, y4, "Under Review", col-bg-agent, col-agent, "underrev")

  // Under Review → Final Review (Agent posts verdict)
  let y5 = y4 - gap-y
  arrow(y4, y5, col-agent, cx)
  label-right(y4, y5, col-agent, [posts verdict], cx)

  // 6. Final Review
  board-card(cx, y5, "Final Review", col-bg-human, col-human, "finalrev")

  // Final Review → Done (Maintainer merges)
  let y6 = y5 - gap-y
  arrow(y5, y6, col-human, cx)
  label-right(y5, y6, col-human, [Maintainer merges], cx)

  // 7. Done
  board-card(cx, y6, "Done", col-bg-human, col-human, "done")

  // --- On Hold: dashed side branch from Final Review ---
  let oh-x = cx + card-w / 2 + 3.2
  rect(
    (oh-x - 0.65, y5 - card-h / 2),
    (oh-x + 0.65, y5 + card-h / 2),
    radius: 3pt,
    fill: col-fail.lighten(88%),
    stroke: 1pt + col-fail,
    name: "onhold",
  )
  content("onhold", text(7pt, weight: "bold", fill: col-fail.darken(10%), [On Hold]))
  line(
    (cx + card-w / 2, y5),
    (oh-x - 0.65 - 0.05, y5),
    stroke: (thickness: 1pt, paint: col-fail, dash: "dashed"),
    mark: (end: "straight", scale: 0.35),
  )
  content(
    ((cx + card-w / 2 + oh-x - 0.65) / 2, y5 + 0.25),
    anchor: "south",
    text(5.5pt, fill: col-fail, style: "italic", [fails]),
  )

  // --- Agent zone bracket on the left ---
  let bx = cx - card-w / 2 - 0.5
  let bracket-top = y1 - card-h / 2 - 0.05
  let bracket-bot = y5 + card-h / 2 + 0.05
  line(
    (bx + 0.12, bracket-top), (bx, bracket-top),
    (bx, bracket-bot), (bx + 0.12, bracket-bot),
    stroke: (thickness: 0.8pt, paint: col-agent, dash: "dashed"),
  )
  content(
    (bx - 0.1, (bracket-top + bracket-bot) / 2), anchor: "east",
    text(6pt, fill: col-agent, weight: "bold", [Agent]),
  )

  // --- Legend at bottom ---
  let ly = y6 - card-h / 2 - 0.6
  let lx = cx - 2.5
  line((lx, ly), (lx + 0.5, ly), stroke: 1.2pt + col-human)
  content((lx + 0.65, ly), anchor: "west", text(6pt, [Human decision]))
  line((lx + 3.0, ly), (lx + 3.5, ly), stroke: 1.2pt + col-agent)
  content((lx + 3.65, ly), anchor: "west", text(6pt, [Agent action]))
})
