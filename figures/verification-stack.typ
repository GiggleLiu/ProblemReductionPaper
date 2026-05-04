#import "lib.typ": *

#set page(..fig-page)
#set text(..fig-text)

// ── Layer data: (number, two-line name as content, novel?) ──
#let layers = (
  (1, [Issue \ review],            false),
  (2, [Compile-time \ type checks], false),
  (3, [Unit \ tests],               false),
  (4, [Round-trip \ tests],         true),
  (5, [Agentic feature \ tests],    true),
  (6, [Manual \ verification],      false),
)

#canvas(length: 1cm, {
  import draw: *

  // Common style helpers
  let arr-style    = (thickness: 0.7pt, paint: luma(140))
  let arr-mark     = (end: "straight", scale: 0.30)
  let arr-mark-bi  = (start: "straight", end: "straight", scale: 0.28)

  // ════════════════ PANEL A: horizontal verification stack ════════════════
  let pa-cy = 0          // panel A row centerline
  let bw    = 1.70
  let bh    = 1.30
  let gap   = 0.13
  let cap-w = 1.40
  let cap-h = bh

  let pa-x0 = 0.0

  // (a) label
  content((pa-x0, pa-cy + bh / 2 + 0.30), anchor: "south-west",
    text(9pt, weight: "bold", fill: fg)[(a)#h(0.4em) Verification stack])

  // input cap (pill)
  let in-cx = pa-x0 + cap-w / 2
  rect(
    (in-cx - cap-w / 2, pa-cy - cap-h / 2),
    (in-cx + cap-w / 2, pa-cy + cap-h / 2),
    radius: cap-h / 2,
    fill: white,
    stroke: (thickness: 1pt, paint: fg),
    name: "input",
  )
  content("input", anchor: "center",
    text(7pt, weight: "bold")[Candidate \ contribution])

  // 6 layer boxes
  let first-cx = pa-x0 + cap-w + gap + bw / 2
  for i in range(6) {
    let (num, name, is-novel) = layers.at(i)
    let cx = first-cx + i * (bw + gap)

    let stroke-c = if is-novel { accent } else { border }
    let fill-c   = if is-novel { accent.lighten(92%) } else { white }
    let stroke-w = if is-novel { 1.4pt } else { 0.9pt }
    let txt-c    = if is-novel { accent.darken(20%) } else { fg }

    rect(
      (cx - bw / 2, pa-cy - bh / 2),
      (cx + bw / 2, pa-cy + bh / 2),
      radius: 4pt,
      fill: fill-c,
      stroke: (thickness: stroke-w, paint: stroke-c),
      name: "L" + str(i),
    )

    // numbered badge — top-left corner
    let badge-r  = 0.18
    let badge-cx = cx - bw / 2 + 0.28
    let badge-cy = pa-cy + bh / 2 - 0.25
    circle(
      (badge-cx, badge-cy), radius: badge-r,
      fill: if is-novel { accent } else { luma(235) },
      stroke: (thickness: 0.7pt, paint: if is-novel { accent } else { border }),
    )
    content((badge-cx, badge-cy), anchor: "center",
      text(7pt, weight: "bold",
        fill: if is-novel { white } else { fg }, str(num)))

    // layer name — centered with explicit line breaks
    content((cx, pa-cy - 0.12), anchor: "center",
      text(7.5pt, weight: "bold", fill: txt-c)[#name])

    // ★ in top-right corner for novel
    if is-novel {
      content((cx + bw / 2 - 0.20, pa-cy + bh / 2 - 0.22), anchor: "center",
        text(8pt, weight: "bold", fill: accent, sym.star))
    }

    // arrow to next box
    if i < 5 {
      let next-cx = first-cx + (i + 1) * (bw + gap)
      line(
        (cx + bw / 2 + 0.02, pa-cy),
        (next-cx - bw / 2 - 0.02, pa-cy),
        stroke: arr-style, mark: arr-mark,
      )
    }
  }

  // arrow input → first box
  line(
    (in-cx + cap-w / 2 + 0.02, pa-cy),
    (first-cx - bw / 2 - 0.02, pa-cy),
    stroke: arr-style, mark: arr-mark,
  )

  // output cap
  let last-cx = first-cx + 5 * (bw + gap)
  let out-cx = last-cx + bw / 2 + gap + cap-w / 2
  rect(
    (out-cx - cap-w / 2, pa-cy - cap-h / 2),
    (out-cx + cap-w / 2, pa-cy + cap-h / 2),
    radius: cap-h / 2,
    fill: accent.lighten(88%),
    stroke: (thickness: 1.3pt, paint: accent),
    name: "output",
  )
  content("output", anchor: "center",
    text(7pt, weight: "bold", fill: accent.darken(20%))[Verified \ library entry])

  // arrow last box → output cap
  line(
    (last-cx + bw / 2 + 0.02, pa-cy),
    (out-cx - cap-w / 2 - 0.02, pa-cy),
    stroke: (thickness: 0.85pt, paint: accent),
    mark: (end: "straight", scale: 0.32),
  )

  // ════════════════ PANEL B: bottom row, two sub-panels ════════════════
  let total-w = out-cx + cap-w / 2 - pa-x0
  let pb-top  = pa-cy - bh / 2 - 0.85   // top of panel B area
  let sub-h   = 3.2
  let sub-gap = 0.40
  let sub-w   = (total-w - sub-gap) / 2

  let sub1-x0 = pa-x0
  let sub2-x0 = pa-x0 + sub-w + sub-gap

  // soft horizontal divider
  line(
    (pa-x0, pa-cy - bh / 2 - 0.45),
    (pa-x0 + total-w, pa-cy - bh / 2 - 0.45),
    stroke: (thickness: 0.5pt, paint: luma(220), dash: "dotted"),
  )

  // (b) label
  content((pa-x0, pb-top + 0.05), anchor: "south-west",
    text(9pt, weight: "bold", fill: fg)[(b)#h(0.4em) How layers 4 and 5 act])

  // shared block helpers (small mechanism boxes)
  let mb-stroke-n = (thickness: 0.85pt, paint: border)
  let mb-stroke-a = (thickness: 1.1pt,  paint: accent)
  let mb-fill-n   = white
  let mb-fill-a   = accent.lighten(92%)

  let mbox(x1, y1, x2, y2, name-id, is-accent, body) = {
    rect(
      (x1, y1), (x2, y2),
      radius: 3pt,
      fill: if is-accent { mb-fill-a } else { mb-fill-n },
      stroke: if is-accent { mb-stroke-a } else { mb-stroke-n },
      name: name-id,
    )
    content(name-id, anchor: "center",
      box(width: (x2 - x1) * 1cm - 5pt, align(center, body)))
  }

  // ─────────── (b.i) Layer 4: round-trip ───────────
  // Pipeline: example → builder → JSON → PDF; builder → CLI;
  // round-trip test = each artifact must agree with the example.
  let s1-top = pb-top - 0.65
  let s1-bot = s1-top - sub-h
  let s1-cy  = (s1-top + s1-bot) / 2 - 0.10

  content((sub1-x0, s1-top - 0.05), anchor: "north-west",
    text(7.5pt, weight: "bold", fill: accent.darken(20%))[
      #sym.star Layer 4 · Round-trip test
    ])

  // canonical example (left, accent)
  let ex-x1 = sub1-x0 + 0.10
  let ex-x2 = ex-x1 + 1.30
  mbox(ex-x1, s1-cy - 0.35, ex-x2, s1-cy + 0.35, "ex", true,
    text(7pt, weight: "bold", fill: accent.darken(20%))[example])

  // builder
  let bd-x1 = sub1-x0 + 1.85
  let bd-x2 = bd-x1 + 1.10
  mbox(bd-x1, s1-cy - 0.30, bd-x2, s1-cy + 0.30, "bd", false,
    text(6.5pt, weight: "bold")[builder])

  // JSON fixture (top branch)
  let bw3 = 0.95
  let json-cx = sub1-x0 + 3.55
  mbox(json-cx - bw3 / 2, s1-cy + 0.25, json-cx + bw3 / 2, s1-cy + 0.85,
    "json", false, text(6.5pt, weight: "bold")[JSON])

  // PDF manual (downstream of JSON)
  let pdf-cx = sub1-x0 + 4.85
  mbox(pdf-cx - bw3 / 2, s1-cy + 0.25, pdf-cx + bw3 / 2, s1-cy + 0.85,
    "pdf", false, text(6.5pt, weight: "bold")[PDF])

  // CLI demo (bottom branch) — aligned with PDF column to make
  // visually clear that PDF and CLI are the two final artifacts.
  let cli-cx = pdf-cx
  mbox(cli-cx - bw3 / 2, s1-cy - 0.85, cli-cx + bw3 / 2, s1-cy - 0.25,
    "cli", false, text(6.5pt, weight: "bold")[CLI])

  // Forward chain
  line("ex.east",  "bd.west",  stroke: arr-style, mark: arr-mark)
  // builder fans up to JSON, down to CLI
  let f-x = (bd-x2 + json-cx - bw3 / 2) / 2
  line("bd.east", (f-x, s1-cy), (f-x, s1-cy + 0.55), "json.west",
    stroke: arr-style, mark: arr-mark)
  line("bd.east", (f-x, s1-cy), (f-x, s1-cy - 0.55), "cli.west",
    stroke: arr-style, mark: arr-mark)
  // JSON renders to PDF
  line("json.east", "pdf.west", stroke: arr-style, mark: arr-mark)

  // Round-trip back: every artifact must agree with example
  // dashed accent arrows from PDF and CLI back toward the example
  let loop-y-up = s1-cy + 1.15
  let loop-y-dn = s1-cy - 1.15
  let s-loop = (thickness: 0.85pt, paint: accent, dash: "dashed")
  // PDF → loop up → back to example
  line("pdf.north",
       (pdf-cx, loop-y-up),
       (ex-x1 + (ex-x2 - ex-x1) / 2, loop-y-up),
       (ex-x1 + (ex-x2 - ex-x1) / 2, s1-cy + 0.36),
       stroke: s-loop, mark: arr-mark)
  // CLI → loop down → back to example
  line("cli.south",
       (cli-cx, loop-y-dn),
       (ex-x1 + (ex-x2 - ex-x1) / 2, loop-y-dn),
       (ex-x1 + (ex-x2 - ex-x1) / 2, s1-cy - 0.36),
       stroke: s-loop, mark: arr-mark)
  // small annotation on the dashed loop
  content(
    ((ex-x1 + ex-x2) / 2 + 1.5, loop-y-up + 0.05), anchor: "south",
    text(5.5pt, fill: accent.darken(10%), style: "italic")[
      every artifact must match the example
    ],
  )

  // ─────────── (b.ii) Layer 5: agentic feature ───────────
  let s2-top = s1-top
  let s2-bot = s1-bot
  let s2-cy  = s1-cy

  // sub-panel title
  content((sub2-x0, s2-top - 0.05), anchor: "north-west",
    text(7.5pt, weight: "bold", fill: accent.darken(20%))[
      #sym.star Layer 5 · Agentic feature test
    ])

  // main agent (top-left of sub-panel)
  let main-x1 = sub2-x0 + 0.20
  let main-x2 = main-x1 + 1.20
  let main-cy = s2-cy + 0.6
  mbox(main-x1, main-cy - 0.30, main-x2, main-cy + 0.30, "main", false,
    text(6.5pt, weight: "bold")[main])

  // fresh-context container around sub-agent
  let fc-x1 = sub2-x0 + 2.00
  let fc-x2 = sub2-x0 + 4.30
  let fc-y2 = s2-cy + 0.30
  let fc-y1 = s2-cy + 0.95
  rect(
    (fc-x1, fc-y2), (fc-x2, fc-y1),
    radius: 4pt,
    fill: luma(248),
    stroke: (thickness: 0.7pt, paint: fg-light, dash: "dashed"),
  )
  // "fresh context" label sits outside, above the dashed box (centered)
  content(((fc-x1 + fc-x2) / 2, fc-y1 + 0.04), anchor: "south",
    text(5.5pt, fill: fg-light, style: "italic")[fresh context])

  // sub-agent inside the fresh-context box
  let sub-x1 = fc-x1 + 0.20
  let sub-x2 = fc-x2 - 0.20
  let sub-cy = (fc-y1 + fc-y2) / 2 - 0.05
  mbox(sub-x1, sub-cy - 0.22, sub-x2, sub-cy + 0.22, "sub", true,
    text(6.5pt, weight: "bold", fill: accent.darken(20%))[sub-agent])

  // CLI surface (right of fresh-context, on main row)
  let cli-x1 = fc-x2 + 0.30
  let cli-x2 = sub2-x0 + sub-w - 0.20
  mbox(cli-x1, main-cy - 0.30, cli-x2, main-cy + 0.30, "cli", false,
    text(6.5pt, weight: "bold")[CLI])

  // report (bottom-center of sub-panel)
  let rep-cx = (sub2-x0 + (sub2-x0 + sub-w)) / 2
  let rep-x1 = rep-cx - 0.65
  let rep-x2 = rep-cx + 0.65
  let rep-cy = s2-cy - 0.95
  mbox(rep-x1, rep-cy - 0.27, rep-x2, rep-cy + 0.27, "rep", false,
    text(6.5pt, weight: "bold")[report])

  // arrows: main → sub (spawn) — label below the arrow
  line("main.east", "sub.west",
    stroke: arr-style, mark: arr-mark, name: "e-spawn")
  content((rel: (0, -0.14), to: "e-spawn.mid"), anchor: "north",
    text(5.5pt, fill: fg-light)[spawn])

  // sub ↔ CLI (probe end-to-end) — bidirectional, label below
  line("sub.east", "cli.west",
    stroke: arr-style, mark: arr-mark-bi, name: "e-probe")
  content((rel: (0, -0.14), to: "e-probe.mid"), anchor: "north",
    text(5.5pt, fill: fg-light)[probe])

  // sub → report (interview)
  line("sub.south", "rep.north",
    stroke: arr-style, mark: arr-mark, name: "e-int")
  content((rel: (0.14, 0), to: "e-int.mid"), anchor: "west",
    text(5.5pt, fill: fg-light)[interview])
})
