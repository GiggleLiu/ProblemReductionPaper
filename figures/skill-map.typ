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

  // Category label
  let cat(pos, label) = {
    content(pos, text(6.5pt, weight: "bold", fill: fg-light, label))
  }

  let cx = 8
  let cy = 7
  let sp = 0.6   // vertical spacing between skills

  // ── Center: CLAUDE.md ──
  rect((cx - 1.8 + 0.08, cy - 0.45 + 0.08), (cx + 1.8 + 0.08, cy + 0.45 + 0.08),
    radius: 5pt, fill: shadow-col, stroke: none)
  rect((cx - 1.8, cy - 0.45), (cx + 1.8, cy + 0.45),
    radius: 5pt, fill: fill-accent, stroke: stroke-accent, name: "claude")
  content("claude", text(9pt, weight: "bold", fill: accent.darken(20%), raw("CLAUDE.md")))

  // ── Top: User ──
  cat((cx, cy + 3.0), [user])
  skill((cx, cy + 2.5), "propose", "u1", mentor: true)
  skill((cx, cy + 2.5 - sp), "tutorial", "u2", mentor: true)

  // ── Bottom-left: Contributor ──
  let cl = (cx - 5.5, cy - 1.5)
  cat((cl.at(0), cl.at(1) + 0.5), [contributor])
  skill((cl.at(0), cl.at(1)), "dev-setup", "c1", mentor: true)
  skill((cl.at(0), cl.at(1) - sp), "add-model", "c2", mentor: true)
  skill((cl.at(0), cl.at(1) - sp*2), "add-rule", "c3", mentor: true)
  skill((cl.at(0), cl.at(1) - sp*3), "issue-to-pr", "c4")
  skill((cl.at(0), cl.at(1) - sp*4), "fix-issue", "c5")
  skill((cl.at(0), cl.at(1) - sp*5), "fix-pr", "c6")
  skill((cl.at(0), cl.at(1) - sp*6), "write-model", "c7")
  skill((cl.at(0), cl.at(1) - sp*7), "write-rule", "c8")

  // ── Bottom-right: Maintainer ──
  let ml = (cx + 5.5, cy - 1.5)
  cat((ml.at(0), ml.at(1) + 0.5), [maintainer])
  skill((ml.at(0), ml.at(1)), "run-pipeline", "m1")
  skill((ml.at(0), ml.at(1) - sp), "review-pipeline", "m2")
  skill((ml.at(0), ml.at(1) - sp*2), "check-issue", "m3")
  skill((ml.at(0), ml.at(1) - sp*3), "review-structural", "m4")
  skill((ml.at(0), ml.at(1) - sp*4), "review-quality", "m5")
  skill((ml.at(0), ml.at(1) - sp*5), "final-review", "m6", mentor: true)
  skill((ml.at(0), ml.at(1) - sp*6), "topology-check", "m7")
  skill((ml.at(0), ml.at(1) - sp*7), "release", "m8")

  // Links from each group to CLAUDE.md
  line("u2.south", "claude.north", stroke: stroke-dashed, mark: arrow-end)
  line("c1.east", "claude.west", stroke: stroke-dashed, mark: arrow-end)
  line("m1.west", "claude.east", stroke: stroke-dashed, mark: arrow-end)

  // Legend
  let lx = cx - 0.7
  let ly = cy - 6.6
  rect((lx - 0.3, ly - 0.15), (lx + 0.3, ly + 0.15),
    radius: 2pt, fill: fill-accent, stroke: (thickness: 0.8pt, paint: accent))
  content((lx + 1.7, ly), text(5.5pt, fill: fg-light, [= mentor skill]))
})
