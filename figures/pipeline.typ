#import "lib.typ": *

#set page(..fig-page)
#set text(..fig-text)

// Role colors
#let col-human = rgb("#f28e2b")   // orange — human
#let col-agent = accent            // steel blue — agent
#let col-fail = rgb("#e15759")     // red — failure path

#canvas(length: 0.55cm, {
  import draw: *

  let box-w = 3.2
  let box-h = 0.9
  let gap-x = 1.4
  let ann-dy = 0.85  // annotation offset below box
  let role-dy = 0.65 // role label offset above box

  // Stage data: (label, color, role above, annotation below, arrow label)
  let stages = (
    ("Propose", col-human,
      [Domain expert],
      [Files structured issue;\ defines problem, example,\ and overhead],
      [triages]),
    ("Validate", col-agent,
      [Impl. agent],
      [Four checks: useful,\ non-trivial, correct,\ complete],
      [picks issue]),
    ("Implement", col-agent,
      [Impl. agent],
      [Issue $arrow.r$ PR via skill\ checklist (9--11 items)],
      [creates PR]),
    ("Review", col-agent,
      [Review agent],
      [3 parallel sub-agents\ + agentic feature test],
      [posts verdict]),
    ("Merge", col-human,
      [Maintainer],
      [Reviews verdict,\ resolves conflicts,\ merges PR],
      [merged]),
    ("Verify", col-human,
      [Domain expert],
      [Checks definition,\ example, and proof\ match original intent],
      []),
  )

  let n = stages.len()

  for (i, (label, col, role, ann, arrow-label)) in stages.enumerate() {
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

    // Stage label inside box
    content(id, text(7.5pt, weight: "bold", fill: col.darken(20%), label))

    // Role label above box
    content(
      (cx, box-h / 2 + role-dy),
      text(6pt, fill: col.darken(10%), align(center, role)),
    )

    // Annotation below box
    content(
      (cx, -box-h / 2 - ann-dy - 0.15),
      text(5.5pt, fill: fg-light, align(center, ann)),
    )

    // Arrow to next with label
    if i < n - 1 {
      let ax-start = cx + box-w / 2 + 0.05
      let ax-end = cx + box-w + gap-x - box-w / 2 - 0.05
      let ax-mid = (ax-start + ax-end) / 2
      line(
        (ax-start, 0),
        (ax-end, 0),
        stroke: (thickness: 1pt, paint: luma(120)),
        mark: (end: "straight", scale: 0.35),
      )
    }
  }

  // Failure arrows to "On Hold"
  let oh-y = -box-h / 2 - ann-dy - 2.2
  let oh-cx = 2.5 * (box-w + gap-x)  // centered between Implement and Review

  // On Hold box
  rect(
    (oh-cx - 1.5, oh-y - 0.35),
    (oh-cx + 1.5, oh-y + 0.35),
    radius: 3pt,
    fill: col-fail.lighten(90%),
    stroke: 0.8pt + col-fail,
    name: "onhold",
  )
  content("onhold", text(7pt, weight: "bold", fill: col-fail.darken(10%), [On Hold]))

  // Failure arrow from Implement (stage 2)
  let impl-cx = 2 * (box-w + gap-x)
  line(
    (impl-cx, -box-h / 2),
    (impl-cx, oh-y + 0.35 + 0.05),
    stroke: (thickness: 0.8pt, paint: col-fail, dash: "dashed"),
    mark: (end: "straight", scale: 0.3),
  )
  content(
    (impl-cx + 0.15, (-box-h / 2 + oh-y + 0.35) / 2), anchor: "west",
    text(5.5pt, fill: col-fail, [fail]),
  )

  // Failure arrow from Review (stage 3)
  let rev-cx = 3 * (box-w + gap-x)
  line(
    (rev-cx, -box-h / 2),
    (rev-cx, oh-y + 0.35 + 0.05),
    stroke: (thickness: 0.8pt, paint: col-fail, dash: "dashed"),
    mark: (end: "straight", scale: 0.3),
  )
  content(
    (rev-cx + 0.15, (-box-h / 2 + oh-y + 0.35) / 2), anchor: "west",
    text(5.5pt, fill: col-fail, [fail]),
  )

  // On Hold annotation
  content(
    (oh-cx, oh-y - 0.35 - 0.5),
    text(5.5pt, fill: fg-light, align(center, [Human triage required])),
  )

  // Legend
  let ly = oh-y - 0.35 - 1.2
  let lx = 0 * (box-w + gap-x) - box-w / 2
  rect((lx, ly - 0.18), (lx + 0.5, ly + 0.18), fill: col-human.lighten(85%), stroke: 0.8pt + col-human, radius: 2pt)
  content((lx + 0.65, ly), anchor: "west", text(6pt, [Human]))
  rect((lx + 2.8, ly - 0.18), (lx + 3.3, ly + 0.18), fill: col-agent.lighten(85%), stroke: 0.8pt + col-agent, radius: 2pt)
  content((lx + 3.45, ly), anchor: "west", text(6pt, [Agent]))
  line((lx + 5.5, ly), (lx + 6.3, ly), stroke: (thickness: 0.8pt, paint: col-fail, dash: "dashed"), mark: (end: "straight", scale: 0.3))
  content((lx + 6.45, ly), anchor: "west", text(6pt, [Failure path]))
})
