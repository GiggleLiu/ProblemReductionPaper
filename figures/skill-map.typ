#import "lib.typ": *

#set page(..fig-page)
#set text(..fig-text)

#canvas(length: 0.45cm, {
  import draw: *

  // ============================================================
  // Panel (a) — Skill execution model (left, x ≈ 0..13)
  // ============================================================

  let pa-header-y = 11.2
  content((1.4, pa-header-y),
    text(8pt, weight: "bold", fill: fg)[(a)], anchor: "west")

  // ── Helper: one row of the execution model ──
  let exec-row(y, kind, accent-side: false) = {
    let cp-name = if kind == "advisor" { "human" } else { "tools" }
    let cp-sub = if kind == "advisor" {
      [domain expert,\ user, reviewer]
    } else {
      [CLI, tests, web,\ compiler]
    }
    let outcome = if kind == "advisor" {
      [guided decision,\ refined intent]
    } else {
      [code, PR,\ review verdict]
    }
    let agent-fill = if accent-side { fill-accent } else { white }
    let node-stroke = if accent-side {
      (paint: accent, thickness: 0.7pt)
    } else {
      (paint: border, thickness: 0.55pt)
    }

    // Row sub-title above
    if accent-side {
      content((0.2, y + 1.05),
        text(7.5pt, weight: "bold", fill: accent.darken(15%))[advisor]
          + h(0.3em)
          + text(5.5pt, fill: fg-light)[(human-in-loop)],
        anchor: "west")
    } else {
      content((0.2, y + 1.05),
        text(7.5pt, weight: "bold", fill: fg)[automation]
          + h(0.3em)
          + text(5.5pt, fill: fg-light)[(autonomous)],
        anchor: "west")
    }

    // SKILL.md box
    let sx = 2.3
    rect((sx - 1.4, y - 0.45), (sx + 1.4, y + 0.45),
      radius: 3pt, fill: fill-light, stroke: stroke-edge, name: kind + "-skill")
    content((sx, y + 0.18), text(6.5pt, weight: "bold", fill: fg, raw("SKILL.md")))
    content((sx, y - 0.22), text(4.8pt, fill: fg-light)[abstract steps])

    // Agent circle
    let ax = 5.6
    circle((ax, y), radius: 0.7, fill: agent-fill, stroke: node-stroke, name: kind + "-agent")
    content((ax, y), text(6pt, weight: "bold", fill: fg)[agent])

    // Counterpart circle
    let cx = 8.3
    circle((cx, y), radius: 0.7, fill: white, stroke: node-stroke, name: kind + "-cp")
    content((cx, y), text(6pt, weight: "bold", fill: fg)[#cp-name])
    // Sub-label below counterpart
    content((cx, y - 1.05), text(4.8pt, fill: fg-light)[#cp-sub])

    // Connectors
    line(kind + "-skill.east", kind + "-agent.west",
      stroke: stroke-edge, mark: arrow-end)
    line(kind + "-agent.east", kind + "-cp.west",
      stroke: stroke-edge, mark: arrow-both)
    line(kind + "-cp.east", (cx + 0.95, y),
      stroke: stroke-edge, mark: arrow-end)
    content((cx + 1.05, y), text(5.5pt, fill: fg)[#outcome], anchor: "west")
  }

  exec-row(9.7, "advisor", accent-side: true)
  exec-row(5.0, "automation")

  // ============================================================
  // Panel (b) — Skills indexed by invoker (right, x ≈ 15..30)
  // ============================================================

  // Inset from edges so column boxes do not overflow
  let c1x = 17.0
  let c4x = 28.0
  let gap = (c4x - c1x) / 3
  let c2x = c1x + gap
  let c3x = c1x + 2 * gap

  content((15.2, pa-header-y),
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
