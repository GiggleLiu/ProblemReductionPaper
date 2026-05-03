#import "lib.typ": *

#set page(..fig-page)
#set text(..fig-text)

#canvas(length: 0.5cm, {
  import draw: *

  // ── Skill node: name (line 1) + 1-line description (line 2) ──
  let skill(x, y, name-id, sk-name, desc, advisor: false) = {
    let box-w = 3.5
    let box-h = 0.62
    let bg = if advisor { fill-accent } else { white }
    let sk = if advisor {
      (thickness: 0.7pt, paint: accent)
    } else {
      (thickness: 0.45pt, paint: border)
    }
    rect(
      (x - box-w, y - box-h),
      (x + box-w, y + box-h),
      radius: 3pt, fill: bg, stroke: sk, name: name-id,
    )
    content(
      (x - box-w + 0.3, y + 0.2),
      text(7.5pt, fill: fg, raw(sk-name)),
      anchor: "west",
    )
    content(
      (x - box-w + 0.3, y - 0.27),
      text(5.5pt, fill: fg-light, desc),
      anchor: "west",
    )
  }

  // ── Sub-group label (small italic header above a stack of skills) ──
  let group-label(x, y, label) = {
    content(
      (x, y),
      text(7pt, weight: "bold", style: "italic", fill: fg-light, raw(label)),
    )
  }

  // ── Geometry ──
  let advisor-x = 4.0
  let auto-mid-x = 16.0
  let auto-x1 = 12.0
  let auto-x2 = 20.0
  let fig-mid = (advisor-x + auto-x2) / 2  // 12.0
  let row-h = 1.45  // vertical spacing between adjacent skill rows

  // ── Spec root ──
  let spec-y = 22.0
  rect(
    (fig-mid - 4.6, spec-y - 0.6),
    (fig-mid + 4.6, spec-y + 0.6),
    radius: 5pt, fill: fill-light, stroke: stroke-edge, name: "root",
  )
  content(
    (fig-mid, spec-y + 0.2),
    text(8.5pt, weight: "bold", fill: fg, raw("CLAUDE.md / AGENTS.md")),
  )
  content(
    (fig-mid, spec-y - 0.28),
    text(5.8pt, fill: fg-light)[project specification],
  )

  // ── Trunk + top-level fork (advisor / automation) ──
  let bar-y = 19.8
  line("root.south", (fig-mid, bar-y), stroke: stroke-edge)
  line((advisor-x, bar-y), (auto-mid-x, bar-y), stroke: stroke-edge)
  line((advisor-x, bar-y), (advisor-x, bar-y - 0.45), stroke: stroke-edge)
  line((auto-mid-x, bar-y), (auto-mid-x, bar-y - 0.45), stroke: stroke-edge)

  // Pane labels
  let pane-y = bar-y - 0.85
  content(
    (advisor-x, pane-y),
    text(8.5pt, weight: "bold", fill: accent.darken(15%))[advisor]
      + h(0.35em)
      + text(5.8pt, fill: fg-light)[(human-in-loop)],
  )
  content(
    (auto-mid-x, pane-y),
    text(8.5pt, weight: "bold", fill: fg)[automation]
      + h(0.35em)
      + text(5.8pt, fill: fg-light)[(autonomous)],
  )

  // Automation pane fans into two sub-columns
  let fan-y = pane-y - 0.55
  line((auto-mid-x, pane-y - 0.25), (auto-mid-x, fan-y), stroke: stroke-edge)
  line((auto-x1, fan-y), (auto-x2, fan-y), stroke: stroke-edge)
  line((auto-x1, fan-y), (auto-x1, fan-y - 0.40), stroke: stroke-edge)
  line((auto-x2, fan-y), (auto-x2, fan-y - 0.40), stroke: stroke-edge)
  // Advisor pane drops straight to its first sub-group
  line((advisor-x, pane-y - 0.25), (advisor-x, pane-y - 0.95), stroke: stroke-edge)

  // ── Skill rows ──
  let row0 = pane-y - 1.35  // y-position of first sub-group label

  // ===== ADVISOR pane: user / contributor / maintainer =====
  group-label(advisor-x, row0, "user")
  skill(advisor-x, row0 - 0.7,                    "u1", "find-solver",  "real problem → solver path",        advisor: true)
  skill(advisor-x, row0 - 0.7 - row-h,            "u2", "find-problem", "solver → reachable problems",       advisor: true)
  skill(advisor-x, row0 - 0.7 - row-h * 2,        "u3", "tutorial",     "guided pred CLI walkthrough",       advisor: true)

  let row1 = row0 - 0.7 - row-h * 2 - 0.85
  group-label(advisor-x, row1, "contributor")
  skill(advisor-x, row1 - 0.7,                    "c1", "propose",      "brainstorm + file new issue",       advisor: true)

  let row2 = row1 - 0.7 - 0.85
  group-label(advisor-x, row2, "maintainer")
  skill(advisor-x, row2 - 0.7,                    "m1", "check-issue",  "review issue quality",              advisor: true)
  skill(advisor-x, row2 - 0.7 - row-h,            "m2", "fix-issue",    "address quality gaps",              advisor: true)
  skill(advisor-x, row2 - 0.7 - row-h * 2,        "m3", "final-review", "pre-merge human review",            advisor: true)
  skill(advisor-x, row2 - 0.7 - row-h * 3,        "m4", "dev-setup",    "install dev tools",                 advisor: true)

  // ===== AUTOMATION pane: 2 sub-columns =====
  // Sub-column 1: build / maintenance
  group-label(auto-x1, row0, "build")
  skill(auto-x1, row0 - 0.7,                      "b1", "run-pipeline", "drive Ready issues forward")
  skill(auto-x1, row0 - 0.7 - row-h,              "b2", "issue-to-pr",  "issue → PR with plan")
  skill(auto-x1, row0 - 0.7 - row-h * 2,          "b3", "add-model",    "implement a problem model")
  skill(auto-x1, row0 - 0.7 - row-h * 3,          "b4", "add-rule",     "implement a reduction rule")
  skill(auto-x1, row0 - 0.7 - row-h * 4,          "b5", "fix-pr",       "address review + CI")

  let rowm = row0 - 0.7 - row-h * 4 - 0.85
  group-label(auto-x1, rowm, "maintenance")
  skill(auto-x1, rowm - 0.7,                      "n1", "release",       "bump version, tag")
  skill(auto-x1, rowm - 0.7 - row-h,              "n2", "update-papers", "refresh reference lib")

  // Sub-column 2: review / write
  group-label(auto-x2, row0, "review")
  skill(auto-x2, row0 - 0.7,                      "r1", "review-pipeline",       "orchestrate sub-reviews")
  skill(auto-x2, row0 - 0.7 - row-h,              "r2", "review-structural",     "structural checklist")
  skill(auto-x2, row0 - 0.7 - row-h * 2,          "r3", "review-quality",        "DRY / KISS / coverage")
  skill(auto-x2, row0 - 0.7 - row-h * 3,          "r4", "verify-reduction",      "proof + 10k random checks")
  skill(auto-x2, row0 - 0.7 - row-h * 4,          "r5", "topology-sanity-check", "graph topology audit")

  let roww = row0 - 0.7 - row-h * 4 - 0.85
  group-label(auto-x2, roww, "write")
  skill(auto-x2, roww - 0.7,                      "w1", "write-model-in-paper", "paper entry for model")
  skill(auto-x2, roww - 0.7 - row-h,              "w2", "write-rule-in-paper",  "paper entry for rule")
})
