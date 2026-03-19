#import "lib.typ": *

#set page(..fig-page)
#set text(..fig-text)

#canvas(length: 0.55cm, {
  import draw: *

  // Skill node; mentor skills get accent tint
  let skill(pos, label, name-id, mentor: false) = {
    let (x, y) = pos
    let bg = if mentor { fill-accent } else { white }
    let sk = if mentor { (thickness: 0.8pt, paint: accent) } else { (thickness: 0.5pt, paint: border) }
    rect((x - 1.6, y - 0.28), (x + 1.6, y + 0.28),
      radius: 3pt, fill: bg, stroke: sk, name: name-id)
    content(name-id, text(6pt, fill: fg, raw(label)))
  }

  // Role node (intermediate tree level)
  let role-node(pos, label, name-id) = {
    let (x, y) = pos
    rect((x - 1.6 + 0.06, y - 0.35 + 0.06), (x + 1.6 + 0.06, y + 0.35 + 0.06),
      radius: 4pt, fill: shadow-col, stroke: none)
    rect((x - 1.6, y - 0.35), (x + 1.6, y + 0.35),
      radius: 4pt, fill: fill-light, stroke: stroke-box, name: name-id)
    content(name-id, text(7pt, weight: "bold", fill: fg, label))
  }

  let sp = 0.6   // vertical spacing between skills

  // Column x-positions
  let ux = 2      // user
  let cx = 7.5    // contributor
  let mx = 13     // maintainer

  // ── Root: CLAUDE.md / AGENTS.md ──
  let rx = 7.5
  let ry = 13
  rect((rx - 2.0 + 0.08, ry - 0.55 + 0.08), (rx + 2.0 + 0.08, ry + 0.55 + 0.08),
    radius: 5pt, fill: shadow-col, stroke: none)
  rect((rx - 2.0, ry - 0.55), (rx + 2.0, ry + 0.55),
    radius: 5pt, fill: fill-accent, stroke: stroke-accent, name: "root")
  content((rx, ry + 0.15), text(8pt, weight: "bold", fill: accent.darken(20%), raw("CLAUDE.md")))
  content((rx, ry - 0.25), text(8pt, weight: "bold", fill: accent.darken(20%), raw("AGENTS.md")))

  // ── Fork structure ──
  let bar-y = 11.5
  // Trunk
  line("root.south", (rx, bar-y), stroke: stroke-edge)
  // Horizontal bar
  line((ux, bar-y), (mx, bar-y), stroke: stroke-edge)

  // ── Role nodes ──
  let role-y = 10.3
  // Drops from bar to role nodes
  line((ux, bar-y), (ux, role-y + 0.35), stroke: stroke-edge)
  line((cx, bar-y), (cx, role-y + 0.35), stroke: stroke-edge)
  line((mx, bar-y), (mx, role-y + 0.35), stroke: stroke-edge)

  role-node((ux, role-y), [user], "r-user")
  role-node((cx, role-y), [contributor], "r-contrib")
  role-node((mx, role-y), [maintainer], "r-maint")

  // ── Skill columns ──
  let s0 = role-y - 0.95   // first skill y

  // Stems from role nodes to first skill
  line("r-user.south", (ux, s0 + 0.28), stroke: stroke-edge)
  line("r-contrib.south", (cx, s0 + 0.28), stroke: stroke-edge)
  line("r-maint.south", (mx, s0 + 0.28), stroke: stroke-edge)

  // User (1 skill)
  skill((ux, s0), "tutorial", "u1", mentor: true)

  // Contributor (9 skills)
  skill((cx, s0), "propose", "c1", mentor: true)
  skill((cx, s0 - sp), "dev-setup", "c2", mentor: true)
  skill((cx, s0 - sp*2), "add-model", "c3", mentor: true)
  skill((cx, s0 - sp*3), "add-rule", "c4", mentor: true)
  skill((cx, s0 - sp*4), "issue-to-pr", "c5")
  skill((cx, s0 - sp*5), "fix-issue", "c6")
  skill((cx, s0 - sp*6), "fix-pr", "c7")
  skill((cx, s0 - sp*7), "write-model", "c8")
  skill((cx, s0 - sp*8), "write-rule", "c9")

  // Maintainer (8 skills)
  skill((mx, s0), "run-pipeline", "m1")
  skill((mx, s0 - sp), "review-pipeline", "m2")
  skill((mx, s0 - sp*2), "check-issue", "m3")
  skill((mx, s0 - sp*3), "review-structural", "m4")
  skill((mx, s0 - sp*4), "review-quality", "m5")
  skill((mx, s0 - sp*5), "final-review", "m6", mentor: true)
  skill((mx, s0 - sp*6), "topology-check", "m7")
  skill((mx, s0 - sp*7), "release", "m8")

  // Legend
  let lx = ux
  let ly = s0 - sp*8 - 0.8
  rect((lx - 0.3, ly - 0.15), (lx + 0.3, ly + 0.15),
    radius: 2pt, fill: fill-accent, stroke: (thickness: 0.8pt, paint: accent))
  content((lx + 1.7, ly), text(5.5pt, fill: fg-light, [= mentor skill]))
})
