#import "lib.typ": *

#set page(..fig-page)
#set text(..fig-text)

#canvas(length: 0.45cm, {
  import draw: *

  // ============================================================
  // Panel (a) — Skill execution model (left, x ≈ 0..13)
  // ============================================================

  let pa-header-y = 12.5
  content((-0.1, pa-header-y),
    text(8pt, weight: "bold", fill: fg)[(a)], anchor: "west")

  // ── Helper: one row of the execution model ──
  // Both rows: human (above agent) + agent ⇄ tools (right) + outcome
  // Advisor:    human ⇄ agent (bidirectional)  — stays in loop
  // Automation: human → agent (one-way down)   — only triggers
  let exec-row(y, kind, accent-side: false) = {
    // Stroke widths: 0.8pt for light, 1.2pt for emphasis (nodes); 0.8pt / 1.0pt (arrows)
    // Agent: same neutral style in both rows (de-emphasised)
    let agent-fill = luma(245)
    let agent-stroke = (paint: edge-col, thickness: 0.8pt)
    // Tools: emphasised (the right-side counterpart, same in both rows)
    let tools-fill = luma(240)
    let tools-stroke = (paint: luma(60), thickness: 1.2pt)
    let tools-loop-stroke = (paint: luma(70), thickness: 1.0pt)
    // Human: emphasised in advisor (the defining loop), de-emphasised in automation
    let human-fill = if accent-side { fill-accent } else { white }
    let human-stroke = if accent-side {
      (paint: accent, thickness: 1.2pt)
    } else {
      (paint: edge-col, thickness: 0.8pt)
    }
    let human-arrow-stroke = if accent-side {
      (paint: accent, thickness: 1.0pt)
    } else {
      (paint: luma(80), thickness: 0.8pt)
    }
    let flow-stroke = (paint: edge-col, thickness: 0.8pt)
    let big-mark-end  = (end: "straight", scale: 0.55)
    let big-mark-both = (start: "straight", end: "straight", scale: 0.55)

    // SKILL.md "document" box (rounded rect + folded corner)
    let sx = 5.0
    let sw = 1.4
    let sh = 0.45
    let fold = 0.22
    rect((sx - sw, y - sh), (sx + sw, y + sh),
      radius: 3pt, fill: fill-light, stroke: (paint: edge-col, thickness: 0.8pt), name: kind + "-skill")
    line(
      (sx + sw - fold, y + sh),
      (sx + sw - fold, y + sh - fold),
      (sx + sw, y + sh - fold),
      close: true,
      fill: white,
      stroke: (paint: edge-col, thickness: 0.5pt),
    )
    content((sx - 0.1, y), text(6.5pt, weight: "bold", fill: fg, raw("SKILL.md")))

    // Row title to the LEFT of SKILL.md (each line centered)
    if accent-side {
      content((sx - sw - 0.3, y),
        align(center, text(7.5pt, weight: "bold", fill: accent.darken(15%))[advisor skill]),
        anchor: "east")
    } else {
      content((sx - sw - 0.3, y),
        align(center, text(7.5pt, weight: "bold", fill: fg)[automation\ skill]),
        anchor: "east")
    }

    // Agent circle (small, neutral — same actor in both rows)
    let ax = 8.0
    let agent-r = 0.65
    circle((ax, y), radius: agent-r, fill: agent-fill, stroke: agent-stroke, name: kind + "-agent")
    content((ax, y), text(6pt, fill: fg)[agent])

    // Tools: gear shape (polygon with alternating inner / outer radius)
    let cx = 12.0
    let tools-r = 0.85
    let n-teeth = 8
    let r-inner = tools-r
    let r-outer = tools-r + 0.18
    let tooth-w = 360deg / n-teeth * 0.5
    let seg = 360deg / n-teeth
    let gear-pts = ()
    for i in range(n-teeth) {
      let c = i * seg
      gear-pts.push((cx + r-inner * calc.cos(c - tooth-w / 2), y + r-inner * calc.sin(c - tooth-w / 2)))
      gear-pts.push((cx + r-outer * calc.cos(c - tooth-w / 2), y + r-outer * calc.sin(c - tooth-w / 2)))
      gear-pts.push((cx + r-outer * calc.cos(c + tooth-w / 2), y + r-outer * calc.sin(c + tooth-w / 2)))
      gear-pts.push((cx + r-inner * calc.cos(c + tooth-w / 2), y + r-inner * calc.sin(c + tooth-w / 2)))
    }
    // Invisible circle for directional anchors (.east, .west)
    circle((cx, y), radius: r-outer, fill: none, stroke: none, name: kind + "-tools")
    // Visible gear shape on top
    line(..gear-pts, close: true, fill: tools-fill, stroke: tools-stroke)
    content((cx, y), text(6pt, fill: fg)[tools])

    // Human rect (above agent, present in both rows; arrow style differs)
    let hx = ax
    let hy = y + 2.2
    let hw = 0.85  // half-width
    let hh = 0.45  // half-height
    rect((hx - hw - 0.1, hy - hh), (hx + hw + 0.1, hy + hh),
      radius: 2pt, fill: human-fill, stroke: human-stroke, name: kind + "-human")
    let cp-label = if accent-side { [human] } else { [invoker] }
    content((hx, hy), text(6pt, weight: "bold", fill: fg, cp-label))
    // Sub-label to the right of the human circle
    let cp-sub-text = if accent-side {
      [*domain expert,\ user, reviewer*]
    } else {
      [*human or other\ agents*]
    }
    let cp-sub-color = if accent-side { accent.darken(15%) } else { fg-light }
    content((hx + hw + 0.35, hy),
      text(6pt, fill: cp-sub-color, cp-sub-text),
      anchor: "west")

    // Connectors
    line(kind + "-skill.east", kind + "-agent.west",
      stroke: flow-stroke, mark: big-mark-end)
    line(kind + "-agent.east", kind + "-tools.west",
      stroke: tools-loop-stroke, mark: big-mark-both)
    // Human ⇄ agent (advisor: two parallel arrows) OR human → agent (automation: one)
    if accent-side {
      let dx = 0.2
      // human → agent (down, left side)
      line((hx - dx, hy - hh), (ax - dx, y + agent-r),
        stroke: human-arrow-stroke, mark: big-mark-end)
      // agent → human (up, right side)
      line((ax + dx, y + agent-r), (hx + dx, hy - hh),
        stroke: human-arrow-stroke, mark: big-mark-end)
    } else {
      line(kind + "-human.south", kind + "-agent.north",
        stroke: human-arrow-stroke, mark: big-mark-end)
    }
    // Arrow label
    let arrow-label = if accent-side { [stays in loop] } else { [only triggers] }
    let arrow-label-color = if accent-side { accent.darken(15%) } else { fg-light }
    content((hx - 3.05, (hy + y) / 2),
      text(6pt, style: "italic", fill: arrow-label-color, arrow-label),
      anchor: "west")
  }

  exec-row(10.0, "advisor", accent-side: true)
  exec-row(5.6, "automation")

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
  let ry = pa-header-y - 0.4
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

  // Legend below panel (b)
  let legend-y = s0 - sp * 3 - 0.85
  let lg1-x = 18.0
  let lg2-x = 23.5
  // Advisor swatch
  rect((lg1-x, legend-y - 0.22), (lg1-x + 0.5, legend-y + 0.22),
    radius: 2pt, fill: fill-accent, stroke: (paint: accent, thickness: 0.7pt))
  content((lg1-x + 0.7, legend-y),
    text(6.5pt, weight: "bold", fill: accent.darken(15%))[advisor skill],
    anchor: "west")
  // Automation swatch
  rect((lg2-x, legend-y - 0.22), (lg2-x + 0.5, legend-y + 0.22),
    radius: 2pt, fill: white, stroke: (paint: border, thickness: 0.5pt))
  content((lg2-x + 0.7, legend-y),
    text(6.5pt, weight: "bold", fill: fg)[automation skill],
    anchor: "west")
})
