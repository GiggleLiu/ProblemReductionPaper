#import "lib.typ": *

#set page(..fig-page)
#set text(..fig-text)

// ── Category palette ──────────────────────────────────────
#let col-std    = luma(60)         // standard: neutral gray
#let col-novel  = accent            // novel: steel blue
#let col-human  = rgb("#f28e2b")    // human-in-the-loop: orange

#let bg-std    = fill-light
#let bg-novel  = accent.lighten(85%)
#let bg-human  = col-human.lighten(85%)

// ── Layer data: (name, what it rejects, category) ─────────
// Categories: "std", "novel", "human"
// Order is the order a contribution traverses (top = entry, bot = ship).
#let layers = (
  ("Issue review (Stage 2)",
   "vague specs, undefined symbols, unsupported claims",
   "std"),
  ("Compile-time type checks",
   "API misuse, type errors (Rust compiler)",
   "std"),
  ("Unit tests (CI)",
   "evaluation and serialization bugs",
   "std"),
  ("Round-trip tests",
   "drift between contributor's example and generated artifact",
   "novel"),
  ("Agentic feature tests (Stage 4)",
   "usability gaps and semantic errors at the CLI surface",
   "novel"),
  ("Manual verification (Stage 6)",
   "subtle misinterpretations of the original math",
   "human"),
)

#canvas(length: 0.55cm, {
  import draw: *

  let n = layers.len()
  let layer-h = 1.05
  let gap = 0.18
  let max-w = 13.0
  let min-w = 6.5
  let cx = 0
  let cap-h = 1.0

  let cat-fill(c) = {
    if c == "std"   { bg-std }
    else if c == "novel" { bg-novel }
    else { bg-human }
  }
  let cat-stroke(c) = {
    if c == "std"   { col-std }
    else if c == "novel" { col-novel }
    else { col-human }
  }

  // ── Top cap: "Candidate contributions" ─────────────────
  let funnel-top = cap-h + 0.5
  let top-y = funnel-top + cap-h
  let top-w = max-w + 1.0

  merge-path(
    close: true, fill: fill-light,
    stroke: (thickness: 1pt, paint: border),
    {
      line(
        (cx - top-w / 2, top-y),
        (cx + top-w / 2, top-y),
        (cx + max-w / 2, funnel-top),
        (cx - max-w / 2, funnel-top),
      )
    },
  )
  content(
    (cx, (top-y + funnel-top) / 2 + 0.18),
    text(8pt, weight: "bold", fill: fg)[Candidate contributions],
  )
  content(
    (cx, (top-y + funnel-top) / 2 - 0.32),
    text(6pt, fill: fg-light, style: "italic")[
      proposed problems, reduction rules, PRs
    ],
  )

  // ── Filter layers ───────────────────────────────────────
  for i in range(n) {
    let t-top = i / n
    let t-bot = (i + 1) / n
    let w-top = max-w - (max-w - min-w) * t-top
    let w-bot = max-w - (max-w - min-w) * t-bot
    let y-top = funnel-top - i * (layer-h + gap)
    let y-bot = y-top - layer-h
    let y-mid = (y-top + y-bot) / 2
    let t-mid = (i + 0.5) / n
    let w-mid = max-w - (max-w - min-w) * t-mid

    let (name, rejects, cat) = layers.at(i)
    let bg-c = cat-fill(cat)
    let st-c = cat-stroke(cat)
    let txt-c = st-c.darken(15%)

    // Trapezoid
    merge-path(
      close: true, fill: bg-c,
      stroke: (thickness: if cat == "novel" { 1.4pt } else { 1pt }, paint: st-c),
      name: "L" + str(i),
      {
        line(
          (cx - w-top / 2, y-top),
          (cx + w-top / 2, y-top),
          (cx + w-bot / 2, y-bot),
          (cx - w-bot / 2, y-bot),
        )
      },
    )

    // Layer name (bold)
    content(
      (cx, y-mid + 0.20),
      text(7.5pt, weight: "bold", fill: txt-c, name),
    )

    // "rejects: …" inside the trapezoid
    content(
      (cx, y-mid - 0.27),
      text(5.5pt, fill: txt-c.lighten(15%), style: "italic",
        [rejects: #rejects]),
    )

    // Right-side: dashed reject arrow into discard bin
    let edge-x = cx + w-mid / 2
    let bin-left = max-w / 2 + 1.6
    line(
      (edge-x + 0.05, y-mid), (bin-left - 0.05, y-mid),
      stroke: (thickness: 0.6pt, paint: st-c.lighten(30%), dash: "dotted"),
      mark: (end: "straight", scale: 0.3),
    )
  }

  // ── Right-side discard bin ─────────────────────────────
  let bin-left = max-w / 2 + 1.6
  let bin-w = 1.4
  let bin-y-top = funnel-top - 0.05
  let bin-y-bot = funnel-top - n * (layer-h + gap) + gap + 0.05
  rect(
    (bin-left, bin-y-bot),
    (bin-left + bin-w, bin-y-top),
    radius: 3pt,
    fill: luma(245),
    stroke: (thickness: 0.8pt, paint: fg-light, dash: "dashed"),
    name: "bin",
  )
  content(
    (bin-left + bin-w / 2, (bin-y-top + bin-y-bot) / 2 + 0.4),
    text(7pt, weight: "bold", fill: fg-light)[Rejected],
  )
  content(
    (bin-left + bin-w / 2, (bin-y-top + bin-y-bot) / 2 - 0.05),
    text(5.5pt, fill: fg-light, style: "italic")[
      sent back\
      for revision
    ],
  )

  // ── Bottom cap: "Verified contribution" ────────────────
  let last-y-bot = funnel-top - (n - 1) * (layer-h + gap) - layer-h
  let bot-y = last-y-bot - 0.30
  let bot-cap-y = bot-y - cap-h
  let bot-w = min-w

  merge-path(
    close: true, fill: accent.lighten(90%),
    stroke: (thickness: 1.3pt, paint: accent.darken(5%)),
    {
      line(
        (cx - bot-w / 2, bot-y),
        (cx + bot-w / 2, bot-y),
        (cx + bot-w / 2 - 0.8, bot-cap-y),
        (cx - bot-w / 2 + 0.8, bot-cap-y),
      )
    },
  )
  content(
    (cx, (bot-y + bot-cap-y) / 2 + 0.18),
    text(8pt, weight: "bold", fill: accent.darken(20%))[Verified contribution],
  )
  content(
    (cx, (bot-y + bot-cap-y) / 2 - 0.32),
    text(6pt, fill: accent.darken(10%), style: "italic")[
      merged into the library
    ],
  )

  // small drop arrow connecting last layer to bottom cap
  line(
    (cx, last-y-bot - 0.04),
    (cx, bot-y + 0.04),
    stroke: (thickness: 0.9pt, paint: accent),
    mark: (end: "straight", scale: 0.35),
  )

  // ── Legend (bottom row) ────────────────────────────────
  let ly = bot-cap-y - 0.85
  let lx0 = cx - max-w / 2 + 0.5

  let chip(x, col, txt) = {
    rect(
      (x, ly - 0.22), (x + 0.55, ly + 0.22),
      fill: col.lighten(85%),
      stroke: (thickness: 0.9pt, paint: col),
    )
    content((x + 0.7, ly), anchor: "west",
      text(6.5pt, fill: fg, txt))
  }

  chip(lx0,         col-std,   [standard checks])
  chip(lx0 + 4.2,   col-novel, [novel \u{2014} this work])
  chip(lx0 + 9.2,   col-human, [human-in-the-loop])
})
