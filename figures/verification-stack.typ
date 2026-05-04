#import "lib.typ": *

#set page(..fig-page)
#set text(..fig-text)

// ── Layer data: (number, name, novel?) ──
#let layers = (
  (1, "Issue review",                 false),
  (2, "Compile-time type checks",     false),
  (3, "Unit tests",                   false),
  (4, "Round-trip tests",             true),
  (5, "Agentic feature tests",        true),
  (6, "Manual verification",          false),
)

#canvas(length: 1cm, {
  import draw: *

  // ════════════════ PANEL A: 6-layer stack ════════════════
  let bw = 5.2
  let bh = 0.80
  let gap = 0.28
  let cap-w = 4.2
  let cap-h = 0.75
  let pa-cx = 0       // center x of panel A

  let n = layers.len()
  let total-stack-h = n * bh + (n - 1) * gap
  let stack-top-y = 0
  let stack-bot-y = stack-top-y - total-stack-h

  // Input cap
  let cap-top-y = stack-top-y + 0.6
  rect(
    (pa-cx - cap-w / 2, cap-top-y),
    (pa-cx + cap-w / 2, cap-top-y + cap-h),
    radius: cap-h / 2,
    fill: white,
    stroke: (thickness: 1pt, paint: fg),
    name: "input",
  )
  content("input", anchor: "center",
    text(8pt, weight: "bold", fill: fg)[Candidate contribution])

  line(
    (pa-cx, cap-top-y - 0.04),
    (pa-cx, stack-top-y - 0.04),
    stroke: (thickness: 1pt, paint: fg),
    mark: (end: "straight", scale: 0.4),
  )

  // Panel A label
  content((pa-cx - bw / 2, cap-top-y + cap-h + 0.32), anchor: "south-west",
    text(9pt, weight: "bold", fill: fg)[(a)#h(0.4em) Verification stack])

  // 6 layer blocks
  for i in range(n) {
    let (num, name, is-novel) = layers.at(i)
    let y-top = stack-top-y - i * (bh + gap)
    let y-bot = y-top - bh
    let y-mid = (y-top + y-bot) / 2

    let stroke-c = if is-novel { accent } else { border }
    let fill-c   = if is-novel { accent.lighten(92%) } else { white }
    let stroke-w = if is-novel { 1.4pt } else { 0.9pt }
    let txt-c    = if is-novel { accent.darken(20%) } else { fg }

    rect(
      (pa-cx - bw / 2, y-bot),
      (pa-cx + bw / 2, y-top),
      radius: 4pt,
      fill: fill-c,
      stroke: (thickness: stroke-w, paint: stroke-c),
      name: "L" + str(i),
    )

    // Numbered badge
    let badge-r = 0.24
    let badge-x = pa-cx - bw / 2 + 0.45
    circle(
      (badge-x, y-mid), radius: badge-r,
      fill: if is-novel { accent } else { luma(235) },
      stroke: (thickness: 0.7pt, paint: if is-novel { accent } else { border }),
    )
    content((badge-x, y-mid), anchor: "center",
      text(7.5pt, weight: "bold",
        fill: if is-novel { white } else { fg }, str(num)))

    // Layer name
    content(
      (badge-x + badge-r + 0.25, y-mid), anchor: "west",
      text(8.5pt, weight: "bold", fill: txt-c, name),
    )

    // Novel-layer indicators: accent stripe + ★
    if is-novel {
      rect(
        (pa-cx + bw / 2 - 0.16, y-bot + 0.10),
        (pa-cx + bw / 2 - 0.06, y-top - 0.10),
        fill: accent, stroke: none,
      )
      content((pa-cx + bw / 2 - 0.40, y-mid), anchor: "east",
        text(8pt, weight: "bold", fill: accent, sym.star))
    }

    // Arrow to next block
    if i < n - 1 {
      let next-top = y-bot - gap
      line(
        (pa-cx, y-bot - 0.04),
        (pa-cx, next-top + 0.04),
        stroke: (thickness: 0.7pt, paint: luma(170)),
        mark: (end: "straight", scale: 0.3),
      )
    }
  }

  // Output cap
  let cap-bot-y = stack-bot-y - 0.6
  rect(
    (pa-cx - cap-w / 2, cap-bot-y - cap-h),
    (pa-cx + cap-w / 2, cap-bot-y),
    radius: cap-h / 2,
    fill: accent.lighten(88%),
    stroke: (thickness: 1.3pt, paint: accent),
    name: "output",
  )
  content("output", anchor: "center",
    text(8pt, weight: "bold", fill: accent.darken(20%))[Verified library entry])
  line(
    (pa-cx, stack-bot-y - 0.04),
    (pa-cx, cap-bot-y + 0.04),
    stroke: (thickness: 1pt, paint: accent),
    mark: (end: "straight", scale: 0.4),
  )

  // ════════════════ PANEL B: mechanism diagrams ════════════════
  let pb-x0 = pa-cx + bw / 2 + 1.5     // left edge of panel B
  let pb-cx = pb-x0 + 3.0              // center x of panel B
  let pb-w  = 6.0                      // overall width

  // Soft vertical divider
  let div-x = pa-cx + bw / 2 + 0.6
  line(
    (div-x, cap-top-y + cap-h + 0.5),
    (div-x, cap-bot-y - cap-h - 0.4),
    stroke: (thickness: 0.5pt, paint: luma(220), dash: "dotted"),
  )

  // Panel B label (top)
  content((pb-x0, cap-top-y + cap-h + 0.32), anchor: "south-west",
    text(9pt, weight: "bold", fill: fg)[(b)#h(0.4em) How the novel layers act])

  // Helpers for compact mechanism boxes
  let mb-fill   = white
  let mb-stroke = (thickness: 0.85pt, paint: border)
  let mb-fill-a = accent.lighten(92%)
  let mb-stroke-a = (thickness: 1.1pt, paint: accent)

  let mbox(cx, cy, w, h, name-id, body) = {
    rect(
      (cx - w / 2, cy - h / 2),
      (cx + w / 2, cy + h / 2),
      radius: 3pt,
      fill: mb-fill,
      stroke: mb-stroke,
      name: name-id,
    )
    content(name-id, anchor: "center",
      box(width: w * 1cm - 6pt, align(center, body)))
  }
  let mbox-a(cx, cy, w, h, name-id, body) = {
    rect(
      (cx - w / 2, cy - h / 2),
      (cx + w / 2, cy + h / 2),
      radius: 3pt,
      fill: mb-fill-a,
      stroke: mb-stroke-a,
      name: name-id,
    )
    content(name-id, anchor: "center",
      box(width: w * 1cm - 6pt, align(center, body)))
  }

  let arr-style = (thickness: 0.7pt, paint: luma(120))
  let arr-mark  = (end: "straight", scale: 0.3)

  // ─── (b.i) Round-trip mechanism ────────────────────────
  // Shown as: contributor's example fans out to 3 artifacts,
  // each compared back to the original.
  let s1-cy = stack-top-y - 1.6   // sub-panel center y
  let s1-title-y = s1-cy + 1.55

  content((pb-x0, s1-title-y + 0.30), anchor: "west",
    text(7.5pt, weight: "bold", fill: accent.darken(20%))[
      #sym.star Layer 4 · Round-trip test
    ])
  content((pb-x0, s1-title-y - 0.05), anchor: "west",
    text(6.5pt, fill: fg-light, style: "italic")[
      acts on internal artifacts: do they all reflect the same example?
    ])

  // canonical example (left, accent — it's the test's anchor)
  mbox-a(pb-x0 + 0.85, s1-cy, 1.65, 0.75, "ex",
    text(7pt, weight: "bold", fill: accent.darken(20%))[canonical \ example])

  // 3 derived artifacts (middle column, stacked)
  let art-cx = pb-x0 + 3.0
  let art-y-step = 0.65
  mbox(art-cx, s1-cy + art-y-step, 1.45, 0.50, "art-json",
    text(6.5pt, weight: "bold")[JSON fixture])
  mbox(art-cx, s1-cy,                1.45, 0.50, "art-pdf",
    text(6.5pt, weight: "bold")[PDF manual])
  mbox(art-cx, s1-cy - art-y-step,   1.45, 0.50, "art-cli",
    text(6.5pt, weight: "bold")[CLI demo])

  // example fans out to artifacts (orthogonal)
  let f1-x = (pb-x0 + 0.85 + 1.65 / 2 + art-cx - 1.45 / 2) / 2
  line("ex.east", (f1-x, s1-cy), (f1-x, s1-cy + art-y-step), "art-json.west",
    stroke: arr-style, mark: arr-mark)
  line("ex.east", "art-pdf.west",
    stroke: arr-style, mark: arr-mark, name: "ef-pdf")
  line("ex.east", (f1-x, s1-cy), (f1-x, s1-cy - art-y-step), "art-cli.west",
    stroke: arr-style, mark: arr-mark)
  content((rel: (0, 0.18), to: "ef-pdf.mid"), anchor: "south",
    text(5.5pt, fill: fg-light)[generate])

  // dashed comparison arrows from each artifact back to "ex"
  let m1-x = pb-x0 + pb-w - 0.5
  // verify node on the right
  mbox-a(m1-x, s1-cy, 1.0, 0.75, "ver",
    text(6.5pt, weight: "bold", fill: accent.darken(20%))[match \ example?])

  line("art-json.east", (m1-x - 0.85, s1-cy + art-y-step), (m1-x - 0.85, s1-cy), "ver.west",
    stroke: arr-style, mark: arr-mark)
  line("art-pdf.east", "ver.west",
    stroke: arr-style, mark: arr-mark)
  line("art-cli.east", (m1-x - 0.85, s1-cy - art-y-step), (m1-x - 0.85, s1-cy), "ver.west",
    stroke: arr-style, mark: arr-mark)

  // ─── (b.ii) Agentic feature mechanism ──────────────────
  let s2-cy = stack-top-y - 5.5
  let s2-title-y = s2-cy + 1.85

  content((pb-x0, s2-title-y + 0.30), anchor: "west",
    text(7.5pt, weight: "bold", fill: accent.darken(20%))[
      #sym.star Layer 5 · Agentic feature test
    ])
  content((pb-x0, s2-title-y - 0.05), anchor: "west",
    text(6.5pt, fill: fg-light, style: "italic")[
      acts on the CLI surface: a fresh sub-agent uses it end-to-end
    ])

  // Main agent on the left
  mbox(pb-x0 + 0.85, s2-cy + 0.6, 1.65, 0.55, "main",
    text(6.5pt, weight: "bold")[main agent])

  // Fresh-context container (dashed) holding sub-agent
  let fc-x1 = pb-x0 + 1.95
  let fc-x2 = pb-x0 + 4.95
  let fc-y1 = s2-cy + 1.1
  let fc-y2 = s2-cy - 1.0
  rect(
    (fc-x1, fc-y2), (fc-x2, fc-y1),
    radius: 4pt,
    fill: luma(248),
    stroke: (thickness: 0.7pt, paint: fg-light, dash: "dashed"),
    name: "fc",
  )
  content((fc-x1 + 0.12, fc-y1 - 0.15), anchor: "north-west",
    text(5pt, fill: fg-light, style: "italic")[fresh context])

  // sub-agent inside fresh context (accent — this is the novel mechanism's heart)
  mbox-a((fc-x1 + fc-x2) / 2, s2-cy + 0.45, 2.4, 0.55, "sub",
    text(6.5pt, weight: "bold", fill: accent.darken(20%))[sub-agent + persona])

  // CLI inside fresh context (the surface being probed)
  mbox((fc-x1 + fc-x2) / 2, s2-cy - 0.5, 2.4, 0.5, "cli",
    text(6.5pt, weight: "bold")[CLI surface])

  // Report on the right
  mbox(pb-x0 + 5.7, s2-cy + 0.6, 1.4, 0.55, "rep",
    text(6.5pt, weight: "bold")[report])

  // arrows: main → sub (spawn), sub ↔ cli (probe), sub → main (interview), main → report
  line("main.east", "sub.west",
    stroke: arr-style, mark: arr-mark, name: "e-spawn")
  content((rel: (0, 0.18), to: "e-spawn.mid"), anchor: "south",
    text(5.5pt, fill: fg-light)[spawn])

  // sub ↔ cli: paired arrows
  line(
    (rel: (-0.4, 0), to: "sub.south"),
    (rel: (-0.4, 0), to: "cli.north"),
    stroke: arr-style, mark: arr-mark,
  )
  line(
    (rel: ( 0.4, 0), to: "cli.north"),
    (rel: ( 0.4, 0), to: "sub.south"),
    stroke: arr-style, mark: arr-mark,
  )
  content(
    ((fc-x1 + fc-x2) / 2 + 0.95, (s2-cy + 0.45 - 0.275 + s2-cy - 0.5 + 0.25) / 2),
    anchor: "west",
    text(5.5pt, fill: fg-light)[probe \ end-to-end],
  )

  // sub → report (interview)
  line("sub.east", "rep.west",
    stroke: arr-style, mark: arr-mark, name: "e-int")
  content((rel: (0, 0.18), to: "e-int.mid"), anchor: "south",
    text(5.5pt, fill: fg-light)[interview])
})
