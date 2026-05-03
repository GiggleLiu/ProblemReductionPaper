#import "lib.typ": *

#set page(..fig-page)
#set text(..fig-text)

#canvas(length: 0.45cm, {
  import draw: *

  // ============================================================
  // Panel (a) — Skill execution model (left, x ≈ 0..13)
  // ============================================================

  let pa-header-y = 14.0
  content((1.3, pa-header-y),
    text(8pt, weight: "bold", fill: fg)[(a)], anchor: "west")

  // ── Helper: one row of the execution model ──
  // Both rows: human (above agent) + agent ⇄ tools (right) + outcome
  // Advisor:    human ⇄ agent (bidirectional)  — stays in loop
  // Automation: human → agent (one-way down)   — only triggers
  let exec-row(y, kind, accent-side: false) = {
    let outcome = if accent-side {
      [guided decision,\ refined intent]
    } else {
      [code, PR,\ review verdict]
    }
    // Agent: same neutral style in both rows
    let agent-fill = luma(245)
    let agent-stroke = (paint: edge-col, thickness: 0.55pt)
    // Tools: same in both rows (agent ⇄ tools loop is identical)
    let tools-fill = luma(240)
    let tools-stroke = (paint: luma(60), thickness: 1.2pt)
    let tools-loop-stroke = (paint: luma(70), thickness: 1.0pt)
    // Human: emphasised in advisor (the defining loop), muted in automation (just trigger)
    let human-fill = if accent-side { fill-accent } else { white }
    let human-stroke = if accent-side {
      (paint: accent, thickness: 1.3pt)
    } else {
      (paint: edge-col, thickness: 0.7pt)
    }
    let human-arrow-stroke = if accent-side {
      (paint: accent, thickness: 1.1pt)
    } else {
      (paint: luma(80), thickness: 0.8pt)
    }
    let flow-stroke = (paint: edge-col, thickness: 0.8pt)
    let big-mark-end  = (end: "straight", scale: 0.55)
    let big-mark-both = (start: "straight", end: "straight", scale: 0.55)
    // Bidirectional for advisor; one-way (down to agent) for automation
    let human-arrow-mark = if accent-side { big-mark-both } else { big-mark-end }

    // Subtitle (centred over SKILL.md, lifted to clear the human node above agent)
    let sub-title-x = 3.7
    if accent-side {
      content((sub-title-x, y + 3.2),
        text(7.5pt, weight: "bold", fill: accent.darken(15%))[advisor skill])
    } else {
      content((sub-title-x, y + 3.2),
        text(7.5pt, weight: "bold", fill: fg)[automation skill])
    }

    // SKILL.md "document" box (rounded rect + folded corner)
    let sx = 3.7
    let sw = 1.4
    let sh = 0.45
    let fold = 0.22
    rect((sx - sw, y - sh), (sx + sw, y + sh),
      radius: 3pt, fill: fill-light, stroke: stroke-edge, name: kind + "-skill")
    line(
      (sx + sw - fold, y + sh),
      (sx + sw - fold, y + sh - fold),
      (sx + sw, y + sh - fold),
      close: true,
      fill: white,
      stroke: (paint: edge-col, thickness: 0.5pt),
    )
    content((sx - 0.1, y), text(6.5pt, weight: "bold", fill: fg, raw("SKILL.md")))

    // Agent circle (small, neutral — same actor in both rows)
    let ax = 7.0
    let agent-r = 0.65
    circle((ax, y), radius: agent-r, fill: agent-fill, stroke: agent-stroke, name: kind + "-agent")
    content((ax, y), text(5.8pt, fill: fg)[agent])

    // Tools circle (right of agent, same in both rows)
    let cx = 9.85
    let tools-r = 0.85
    circle((cx, y), radius: tools-r, fill: tools-fill, stroke: tools-stroke, name: kind + "-tools")
    content((cx, y), text(6pt, weight: "bold", fill: fg)[tools])
    content((cx, y - 1.5), text(4.8pt, fill: fg-light)[CLI, tests, web,\ compiler])

    // Human circle (above agent, present in both rows; arrow style differs)
    let hx = ax
    let hy = y + 2.2
    let hr = 0.75
    circle((hx, hy), radius: hr, fill: human-fill, stroke: human-stroke, name: kind + "-human")
    content((hx, hy), text(5.5pt, weight: "bold", fill: fg)[human])
    // Sub-label to the right of the human circle (advisor only)
    if accent-side {
      content((hx + hr + 0.15, hy),
        text(4.8pt, fill: fg-light)[domain expert,\ user, reviewer],
        anchor: "west")
    }

    // Connectors
    line(kind + "-skill.east", kind + "-agent.west",
      stroke: flow-stroke, mark: big-mark-end)
    line(kind + "-agent.east", kind + "-tools.west",
      stroke: tools-loop-stroke, mark: big-mark-both)
    line(kind + "-tools.east", (cx + 1.7, y),
      stroke: flow-stroke, mark: big-mark-end)
    content((cx + 1.85, y), text(5.5pt, fill: fg)[#outcome], anchor: "west")
    // Human ⇄ agent (advisor) OR human → agent (automation)
    line(kind + "-human.south", kind + "-agent.north",
      stroke: human-arrow-stroke, mark: human-arrow-mark)
  }

  exec-row(10.0, "advisor", accent-side: true)
  exec-row(4.5, "automation")

  // ============================================================
  // Panel (b) — Skills indexed by invoker (right, x ≈ 15..30)
  // ============================================================

  // Inset from edges so column boxes do not overflow
  let c1x = 17.0
  let c4x = 28.0
  let gap = (c4x - c1x) / 3
  let c2x = c1x + gap
  let c3x = c1x + 2 * gap

  content((14.9, pa-header-y),
    text(8pt, weight: "bold", fill: fg)[(b)], anchor: "west")

  // Skill node
  let skill(pos, label, name-id, mentor: false) = {
    let (x, y) = pos
    let bg = if mentor { fill-accent } else { white }
    let sk = if mentor {
      (thickness: 0.7pt, paint: accent)
    } else {
      (thickness: 0.45pt, paint: border)
    }
    rect((x - 1.7, y - 0.34), (x + 1.7, y + 0.34),
      radius: 3pt, fill: bg, stroke: sk, name: name-id)
    content(name-id, text(6pt, fill: fg, raw(label)))
  }

  // Root spec node
  let rx = (c1x + c4x) / 2
  let ry = pa-header-y - 1.0
  rect((rx - 4.0, ry - 0.55), (rx + 4.0, ry + 0.55),
    radius: 5pt, fill: fill-light, stroke: stroke-edge, name: "root")
  content((rx, ry), text(7.5pt, weight: "bold", raw("CLAUDE.md / AGENTS.md")))
  // content((rx, ry - 0.22), text(5pt, fill: fg-light)[project specification])

  // Trunk + bar + ticks
  let bar-y = ry - 1.55
  let tick-len = 0.5
  line("root.south", (rx, bar-y), stroke: stroke-edge)
  line((c1x, bar-y), (c4x, bar-y), stroke: stroke-edge)
  for x in (c1x, c2x, c3x, c4x) {
    line((x, bar-y), (x, bar-y - tick-len), stroke: stroke-edge)
  }

  // Column headers
  let hdr-y = bar-y - tick-len - 0.32
  content((c1x, hdr-y), text(7.5pt, weight: "bold", fill: fg)[user])
  content((c2x, hdr-y), text(7.5pt, weight: "bold", fill: fg)[contributor])
  content((c3x, hdr-y), text(7.5pt, weight: "bold", fill: fg)[maintainer])
  content((c4x, hdr-y), text(7.5pt, weight: "bold", fill: fg)[agent])

  // Skill rows
  let sp = 0.92
  let s0 = hdr-y - 0.85

  // user (advisor)
  skill((c1x, s0),         "find-solver",     "u1", mentor: true)
  skill((c1x, s0 - sp),    "find-problem",    "u2", mentor: true)

  // contributor (advisor)
  skill((c2x, s0),         "propose",         "c1", mentor: true)

  // maintainer: advisor on top, automation below
  skill((c3x, s0),         "fix-issue",       "m1", mentor: true)
  skill((c3x, s0 - sp),    "final-review",    "m2", mentor: true)
  skill((c3x, s0 - sp*2),  "dev-setup",       "m3")
  skill((c3x, s0 - sp*3),  "release",         "m4")

  // agent (automation)
  skill((c4x, s0),         "check-issue",     "a1")
  skill((c4x, s0 - sp),    "run-pipeline",    "a2")
  skill((c4x, s0 - sp*2),  "review-pipeline", "a3")
})
