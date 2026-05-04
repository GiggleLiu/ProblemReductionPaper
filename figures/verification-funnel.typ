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

// ── Layer data: (name, what it rejects, category, badge) ──
// Categories: "std", "novel", "human"
// Order is the order a contribution traverses (top = entry, bot = ship).
#let layers = (
  ("Issue review (Stage 2)",
   "vague specs, undefined symbols, unsupported claims",
   "std", none),
  ("Compile-time type checks",
   "API misuse, type errors (Rust compiler)",
   "std", none),
  ("Unit tests (CI)",
   "evaluation and serialization bugs",
   "std", none),
  ("Round-trip tests",
   "drift between contributor's example and generated artifact",
   "novel", "novel"),
  ("Agentic feature tests (Stage 4)",
   "usability gaps and semantic errors at the CLI surface",
   "novel", "novel"),
  ("Manual verification (Stage 6)",
   "subtle misinterpretations of the original math",
   "human", none),
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

    let (name, rejects, cat, badge) = layers.at(i)
    let bg-c = cat-fill(cat)
    let st-c = cat-stroke(cat)
    let txt-c = st-c.darken(15%)

    // Trapezoid
    merge-path(
      close: true, fill: bg-c,
      stroke: (thickness: if cat == "novel" { 1.3pt } else { 1pt }, paint: st-c),
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
      (cx, y-mid + 0.18),
      text(7.5pt, weight: "bold", fill: txt-c, name),
    )

    // Subtle badge for novel layers
    if badge == "novel" {
      content(
        (cx + w-mid / 2 - 1.2, y-mid + 0.18), anchor: "east",
        text(5.5pt, weight: "bold", fill: col-novel,
          [#sym.star this work]),
      )
    }

    // "rejects: …" inside the trapezoid
    content(
      (cx, y-mid - 0.28),
      text(5.5pt, fill: txt-c.lighten(15%), style: "italic",
        [rejects: #rejects]),
    )

    // Right-side: dashed reject arrow + bin label
    let edge-x = cx + w-mid / 2
    let bin-x = max-w / 2 + 1.0
    line(
      (edge-x + 0.05, y-mid), (bin-x - 0.05, y-mid),
      stroke: (thickness: 0.5pt, paint: st-c.lighten(35%), dash: "dotted"),
      mark: (end: "straight", scale: 0.3),
    )
  }

  // Discard label on the right (single label spans whole funnel)
  let discard-y-top = funnel-top - 0.2
  let discard-y-bot = funnel-top - n * (layer-h + gap)
  let bin-x = max-w / 2 + 1.0
  content(
    (bin-x + 0.1, (discard-y-top + discard-y-bot) / 2 + 0.5),
    anchor: "west", angle: 0deg,
    text(6.5pt, weight: "bold", fill: fg-light)[Rejected /\ sent back],
  )

  // ── Bottom cap: "Verified code" ────────────────────────
  let last-y-bot = funnel-top - (n - 1) * (layer-h + gap) - layer-h
  let bot-y = last-y-bot - 0.25
  let bot-cap-y = bot-y - cap-h
  let bot-w = min-w

  merge-path(
    close: true, fill: accent.lighten(90%),
    stroke: (thickness: 1.2pt, paint: accent.darken(5%)),
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
    (cx, (bot-y + bot-cap-y) / 2 + 0.15),
    text(8pt, weight: "bold", fill: accent.darken(20%))[Verified contribution],
  )
  content(
    (cx, (bot-y + bot-cap-y) / 2 - 0.32),
    text(6pt, fill: accent.darken(10%), style: "italic")[
      merged into the library
    ],
  )

  // ── Left side: category brackets ───────────────────────
  let bx-left = cx - max-w / 2 - 0.5

  // Compute spans for each category
  let cat-of(i) = layers.at(i).at(2)
  let std-indices = range(n).filter(i => cat-of(i) == "std")
  let novel-indices = range(n).filter(i => cat-of(i) == "novel")
  let human-indices = range(n).filter(i => cat-of(i) == "human")

  let span-y(indices) = {
    let i-top = indices.first()
    let i-bot = indices.last()
    let y-top = funnel-top - i-top * (layer-h + gap)
    let y-bot = funnel-top - (i-bot + 1) * (layer-h + gap) + gap
    (y-top, y-bot)
  }

  let draw-bracket(indices, label-text, col) = {
    let (y-t, y-b) = span-y(indices)
    let xL = bx-left
    let xR = bx-left + 0.28
    line(
      (xR, y-t), (xL, y-t), (xL, y-b), (xR, y-b),
      stroke: (thickness: 1pt, paint: col),
    )
    content(
      (xL - 0.18, (y-t + y-b) / 2),
      anchor: "east", angle: 90deg,
      text(7pt, weight: "bold", fill: col, label-text),
    )
  }

  draw-bracket(std-indices,   [Standard checks],            col-std)
  draw-bracket(novel-indices, [Novel — this work],          col-novel)
  draw-bracket(human-indices, [Human-in-the-loop],          col-human)

  // ── Legend (bottom) ────────────────────────────────────
  let ly = bot-cap-y - 0.7
  let lx0 = cx - max-w / 2 + 0.5

  let chip(x, col, txt) = {
    rect(
      (x, ly - 0.18), (x + 0.45, ly + 0.18),
      fill: col.lighten(85%),
      stroke: (thickness: 0.8pt, paint: col),
    )
    content((x + 0.55, ly), anchor: "west",
      text(6pt, fill: fg, txt))
  }

  chip(lx0, col-std, [standard])
  chip(lx0 + 3.2, col-novel, [novel — this work])
  chip(lx0 + 7.0, col-human, [human review])
})
