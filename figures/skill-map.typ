#import "lib.typ": *

#set page(..fig-page)
#set text(..fig-text)

#canvas(length: 0.5cm, {
  import draw: *

  // ===========================================================
  // Panel (a) — Skill execution models
  // ===========================================================
  // Two side-by-side mini diagrams illustrating the two ways a
  // skill is executed: advisor (agent ↔ human dialog) vs
  // automation (agent ↔ tools loop).

  let pa-top = 18.5
  let A-x = 7.0   // advisor sub-panel center
  let B-x = 21.0  // automation sub-panel center

  // ── Panel header ──
  content((1.0, pa-top + 0.5),
    text(8pt, weight: "bold", fill: fg, raw("(a)")), anchor: "west")
  content((3.0, pa-top + 0.5),
    text(7.5pt, style: "italic", fill: fg)[skill execution model], anchor: "west")

  // ── Helper: draw a single execution-model diagram ──
  let exec-model(cx, kind, accent-side: false) = {
    let cp-name = if kind == "advisor" { "human" } else { "tools" }
    let cp-sub = if kind == "advisor" { "(domain expert,\nuser, reviewer)" } else { "(CLI, tests, web,\ncompiler)" }
    let arrow-tag = if kind == "advisor" { "dialog" } else { "tool calls" }
    let outcome = if kind == "advisor" {
      "guided decision, refined intent,\nbrainstormed issue"
    } else {
      "code, PR, review verdict,\npaper draft"
    }
    let panel-stroke = if accent-side {
      (paint: accent, thickness: 0.7pt)
    } else {
      (paint: border, thickness: 0.5pt)
    }
    let agent-fill = if accent-side { fill-accent } else { white }
    let agent-stroke = if accent-side {
      (paint: accent, thickness: 0.7pt)
    } else {
      (paint: border, thickness: 0.6pt)
    }

    // Sub-panel title
    if accent-side {
      content((cx, pa-top - 0.05),
        text(8pt, weight: "bold", fill: accent.darken(15%))[advisor]
          + h(0.3em)
          + text(6pt, fill: fg-light)[(human-in-loop)])
    } else {
      content((cx, pa-top - 0.05),
        text(8pt, weight: "bold", fill: fg)[automation]
          + h(0.3em)
          + text(6pt, fill: fg-light)[(autonomous)])
    }

    // SKILL.md node
    let sky = pa-top - 1.1
    rect((cx - 1.7, sky - 0.45), (cx + 1.7, sky + 0.45),
      radius: 3pt, fill: fill-light, stroke: stroke-edge, name: kind + "-skill")
    content((cx, sky + 0.18), text(7pt, weight: "bold", fill: fg, raw("SKILL.md")))
    content((cx, sky - 0.22), text(5.5pt, fill: fg-light)[abstract steps + intent])

    // Agent and counterpart
    let ay = pa-top - 3.1
    let agent-pos = (cx - 1.6, ay)
    let cp-pos = (cx + 1.6, ay)
    circle(agent-pos, radius: 0.75, fill: agent-fill, stroke: agent-stroke, name: kind + "-agent")
    content(agent-pos, text(6.5pt, weight: "bold", fill: fg)[agent])
    circle(cp-pos, radius: 0.75, fill: white, stroke: agent-stroke, name: kind + "-cp")
    content(cp-pos, text(6.5pt, weight: "bold", fill: fg)[#cp-name])

    // Skill → agent
    line(kind + "-skill.south", kind + "-agent.north",
      stroke: stroke-edge, mark: arrow-end)
    // Agent ⇄ counterpart
    line(kind + "-agent.east", kind + "-cp.west",
      stroke: stroke-edge, mark: arrow-both)
    content((cx, ay + 0.32), text(5.5pt, style: "italic", fill: fg-light)[#arrow-tag])

    // Counterpart sub-label
    content((cx + 1.6, ay - 1.1), text(5pt, fill: fg-light)[#cp-sub])

    // Agent → outcome
    let oy = pa-top - 5.4
    line(kind + "-agent.south", (cx - 1.6, oy + 0.45),
      stroke: stroke-edge, mark: arrow-end)
    content((cx, oy), text(6.2pt, fill: fg)[#outcome])
  }

  exec-model(A-x, "advisor", accent-side: true)
  exec-model(B-x, "automation")

  // Faint vertical separator between (a) sub-panels
  line((14.0, pa-top + 0.2), (14.0, pa-top - 5.8),
    stroke: (paint: luma(225), thickness: 0.4pt, dash: "dotted"))

  // ===========================================================
  // Panel (b) — Skills indexed by invoker (original layout)
  // ===========================================================

  // Skill node; advisor skills get accent tint
  let skill(pos, label, name-id, mentor: false) = {
    let (x, y) = pos
    let bg = if mentor { fill-accent } else { white }
    let sk = if mentor {
      (thickness: 0.8pt, paint: accent)
    } else {
      (thickness: 0.5pt, paint: border)
    }
    rect((x - 2.6, y - 0.36), (x + 2.6, y + 0.36),
      radius: 3pt, fill: bg, stroke: sk, name: name-id)
    content(name-id, text(7pt, fill: fg, raw(label)))
  }

  let sp = 0.95

  // Column x-positions (4 columns spanning the same width as panel (a))
  let c1x = 3.0
  let c2x = 10.0
  let c3x = 17.0
  let c4x = 24.0

  // Panel header
  let pb-top = 11.6
  content((1.0, pb-top + 0.5),
    text(8pt, weight: "bold", fill: fg, raw("(b)")), anchor: "west")
  content((3.0, pb-top + 0.5),
    text(7.5pt, style: "italic", fill: fg)[skills indexed by invoker], anchor: "west")

  // Root
  let rx = (c1x + c4x) / 2
  let ry = pb-top
  rect((rx - 3.0, ry - 0.55), (rx + 3.0, ry + 0.55),
    radius: 5pt, fill: fill-light, stroke: stroke-edge, name: "root")
  content((rx, ry + 0.15), text(8.5pt, weight: "bold", raw("CLAUDE.md / AGENTS.md")))
  content((rx, ry - 0.25), text(5.5pt, fill: fg-light)[project specification])

  // Trunk + horizontal bar + ticks
  let bar-y = pb-top - 1.6
  let tick-len = 0.55
  line("root.south", (rx, bar-y), stroke: stroke-edge)
  line((c1x, bar-y), (c4x, bar-y), stroke: stroke-edge)
  for x in (c1x, c2x, c3x, c4x) {
    line((x, bar-y), (x, bar-y - tick-len), stroke: stroke-edge)
  }

  // Column headers
  let hdr-y = bar-y - tick-len - 0.35
  content((c1x, hdr-y), text(8pt, weight: "bold", fill: fg)[user])
  content((c2x, hdr-y), text(8pt, weight: "bold", fill: fg)[contributor])
  content((c3x, hdr-y), text(8pt, weight: "bold", fill: fg)[maintainer])
  content((c4x, hdr-y), text(8pt, weight: "bold", fill: fg)[agent])

  // Skill rows
  let s0 = hdr-y - 0.95

  // user (advisor)
  skill((c1x, s0),         "find-solver",   "u1", mentor: true)
  skill((c1x, s0 - sp),    "find-problem",  "u2", mentor: true)

  // contributor (advisor)
  skill((c2x, s0),         "propose",       "c1", mentor: true)

  // maintainer: advisor on top, automation below
  skill((c3x, s0),         "fix-issue",     "m1", mentor: true)
  skill((c3x, s0 - sp),    "final-review",  "m2", mentor: true)
  skill((c3x, s0 - sp*2),  "dev-setup",     "m3")
  skill((c3x, s0 - sp*3),  "release",       "m4")

  // agent (automation)
  skill((c4x, s0),         "check-issue",     "a1")
  skill((c4x, s0 - sp),    "run-pipeline",    "a2")
  skill((c4x, s0 - sp*2),  "review-pipeline", "a3")
})
