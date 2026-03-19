#import "lib.typ": *

#set page(..fig-page)
#set text(..fig-text)

#canvas(length: 0.55cm, {
  import draw: *

  // Helper: skill node
  let skill(pos, label, name-id) = {
    let (x, y) = pos
    rect((x - 1.6, y - 0.28), (x + 1.6, y + 0.28),
      radius: 3pt, fill: white, stroke: (thickness: 0.5pt, paint: border), name: name-id)
    content(name-id, text(6pt, fill: fg, raw(label)))
  }

  // Helper: category label
  let cat(pos, label) = {
    content(pos, text(6pt, weight: "bold", fill: fg-light, label))
  }

  let cx = 8
  let cy = 6

  // ── Center: CLAUDE.md ──
  rect((cx - 1.8 + 0.08, cy - 0.45 + 0.08), (cx + 1.8 + 0.08, cy + 0.45 + 0.08),
    radius: 5pt, fill: shadow-col, stroke: none)
  rect((cx - 1.8, cy - 0.45), (cx + 1.8, cy + 0.45),
    radius: 5pt, fill: fill-accent, stroke: stroke-accent, name: "claude")
  content("claude", text(9pt, weight: "bold", fill: accent.darken(20%), raw("CLAUDE.md")))

  // ── Top-left: Orchestration ──
  let ol = (cx - 5.5, cy + 4.0)
  cat((ol.at(0), ol.at(1) + 0.5), [orchestration])
  skill((ol.at(0), ol.at(1)), "run-pipeline", "s1")
  skill((ol.at(0), ol.at(1) - 0.7), "issue-to-pr", "s2")
  skill((ol.at(0), ol.at(1) - 1.4), "review-pipeline", "s3")
  skill((ol.at(0), ol.at(1) - 2.1), "release", "s4")

  // ── Top-right: Verification ──
  let vr = (cx + 5.5, cy + 4.0)
  cat((vr.at(0), vr.at(1) + 0.5), [verification])
  skill((vr.at(0), vr.at(1)), "check-issue", "s5")
  skill((vr.at(0), vr.at(1) - 0.7), "review-structural", "s6")
  skill((vr.at(0), vr.at(1) - 1.4), "review-quality", "s7")
  skill((vr.at(0), vr.at(1) - 2.1), "final-review", "s8")
  skill((vr.at(0), vr.at(1) - 2.8), "topology-check", "s9")

  // ── Bottom-left: Authoring ──
  let al = (cx - 5.5, cy - 3.0)
  cat((al.at(0), al.at(1) + 0.5), [authoring])
  skill((al.at(0), al.at(1)), "add-model", "s10")
  skill((al.at(0), al.at(1) - 0.7), "add-rule", "s11")
  skill((al.at(0), al.at(1) - 1.4), "fix-issue", "s12")
  skill((al.at(0), al.at(1) - 2.1), "fix-pr", "s13")

  // ── Bottom-right: Onboarding & docs ──
  let dr = (cx + 5.5, cy - 3.0)
  cat((dr.at(0), dr.at(1) + 0.5), [onboarding & docs])
  skill((dr.at(0), dr.at(1)), "propose", "s14")
  skill((dr.at(0), dr.at(1) - 0.7), "dev-setup", "s15")
  skill((dr.at(0), dr.at(1) - 1.4), "tutorial", "s16")
  skill((dr.at(0), dr.at(1) - 2.1), "write-model", "s17")
  skill((dr.at(0), dr.at(1) - 2.8), "write-rule", "s18")

  // Dashed links from nearest skill in each group to CLAUDE.md
  line("s4.east", "claude.north-west", stroke: stroke-dashed, mark: arrow-end)
  line("s9.west", "claude.north-east", stroke: stroke-dashed, mark: arrow-end)
  line("s10.east", "claude.south-west", stroke: stroke-dashed, mark: arrow-end)
  line("s14.west", "claude.south-east", stroke: stroke-dashed, mark: arrow-end)
})
