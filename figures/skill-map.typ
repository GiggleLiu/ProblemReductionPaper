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

  let sp = 0.6

  // Column x-positions (4 columns)
  let c1x = 1.8
  let c2x = 6.0
  let c3x = 10.2
  let c4x = 14.4

  // ── Root ──
  let rx = 8.1
  let ry = 12.5
  rect((rx - 2.0 + 0.08, ry - 0.55 + 0.08), (rx + 2.0 + 0.08, ry + 0.55 + 0.08),
    radius: 5pt, fill: shadow-col, stroke: none)
  rect((rx - 2.0, ry - 0.55), (rx + 2.0, ry + 0.55),
    radius: 5pt, fill: fill-accent, stroke: stroke-accent, name: "root")
  content((rx, ry + 0.15), text(8pt, weight: "bold", fill: accent.darken(20%), raw("CLAUDE.md")))
  content((rx, ry - 0.25), text(8pt, weight: "bold", fill: accent.darken(20%), raw("AGENTS.md")))

  // ── Fork: trunk + bar + ticks ──
  let bar-y = 11.0
  let tick-len = 0.6
  // Trunk
  line("root.south", (rx, bar-y), stroke: stroke-edge)
  // Horizontal bar
  line((c1x, bar-y), (c4x, bar-y), stroke: stroke-edge)
  // Tick marks
  for x in (c1x, c2x, c3x, c4x) {
    line((x, bar-y), (x, bar-y - tick-len), stroke: stroke-edge)
  }

  // ── Column headers (plain text, not boxes) ──
  let hdr-y = bar-y - tick-len - 0.25
  content((c1x, hdr-y), text(7pt, weight: "bold", fill: fg-light, [user]))
  content((c2x, hdr-y), text(7pt, weight: "bold", fill: fg-light, [contributor]))
  content((c3x, hdr-y), text(7pt, weight: "bold", fill: fg-light, [maintainer]))
  content((c4x, hdr-y), text(7pt, weight: "bold", fill: fg-light, [automation]))

  // ── Skills ──
  let s0 = hdr-y - 0.65

  // User (1 skill)
  skill((c1x, s0), "tutorial", "u1", mentor: true)

  // Contributor (4 mentor skills)
  skill((c2x, s0), "propose", "c1", mentor: true)
  skill((c2x, s0 - sp), "dev-setup", "c2", mentor: true)
  skill((c2x, s0 - sp*2), "add-model", "c3", mentor: true)
  skill((c2x, s0 - sp*3), "add-rule", "c4", mentor: true)

  // Maintainer (2 interactive skills)
  skill((c3x, s0), "final-review", "m1", mentor: true)
  skill((c3x, s0 - sp), "fix-issue", "m2", mentor: true)

  // Automation (11 fully autonomous skills)
  skill((c4x, s0), "run-pipeline", "a1")
  skill((c4x, s0 - sp), "issue-to-pr", "a2")
  skill((c4x, s0 - sp*2), "review-pipeline", "a3")
  skill((c4x, s0 - sp*3), "check-issue", "a4")
  skill((c4x, s0 - sp*4), "review-structural", "a5")
  skill((c4x, s0 - sp*5), "review-quality", "a6")
  skill((c4x, s0 - sp*6), "fix-pr", "a7")
  skill((c4x, s0 - sp*7), "topology-check", "a8")
  skill((c4x, s0 - sp*8), "write-model", "a9")
  skill((c4x, s0 - sp*9), "write-rule", "a10")
  skill((c4x, s0 - sp*10), "release", "a11")

  // Legend
  let lx = c1x
  let ly = s0 - sp*10 - 0.7
  rect((lx - 0.3, ly - 0.15), (lx + 0.3, ly + 0.15),
    radius: 2pt, fill: fill-accent, stroke: (thickness: 0.8pt, paint: accent))
  content((lx + 1.7, ly), text(5.5pt, fill: fg-light, [= mentor skill]))
})
