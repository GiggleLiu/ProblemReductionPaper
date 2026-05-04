#import "lib.typ": *

#set page(..fig-page)
#set text(..fig-text)

// ── Layer data: (number, name, what it rejects, novel?) ──
#let layers = (
  (1, "Issue review",                 "vague specs, unsupported claims",        false),
  (2, "Compile-time type checks",     "API misuse, type errors",                false),
  (3, "Unit tests",                   "evaluation and serialization bugs",       false),
  (4, "Round-trip tests",             "drift between contributor's intent and the artifact",  true),
  (5, "Agentic feature tests",        "usability and semantic errors at the CLI surface",     true),
  (6, "Manual verification",          "subtle misinterpretations of the original math",       false),
)

#canvas(length: 1cm, {
  import draw: *

  // Layout
  let bw = 7.0       // block width (cm units, since length=1cm)
  let bh = 0.78      // block height
  let gap = 0.32     // vertical gap between blocks
  let cap-w = 4.6
  let cap-h = 0.85
  let rejects-x = bw / 2 + 0.35  // x for right-side "rejects: ..." labels

  let n = layers.len()
  let total-stack-h = n * bh + (n - 1) * gap

  // y of the top edge of the stack
  let stack-top-y = 0
  let stack-bot-y = stack-top-y - total-stack-h

  // ── Top cap: input ────────────────────────────────────
  let cap-top-y = stack-top-y + 0.7
  rect(
    (-cap-w / 2, cap-top-y),
    ( cap-w / 2, cap-top-y + cap-h),
    radius: cap-h / 2,                       // pill shape
    fill: white,
    stroke: (thickness: 1pt, paint: fg),
    name: "input",
  )
  content(
    "input", anchor: "center",
    text(8.5pt, weight: "bold", fill: fg)[Candidate contribution],
  )

  // arrow from input cap into stack
  line(
    (0, cap-top-y - 0.04),
    (0, stack-top-y - 0.04),
    stroke: (thickness: 1pt, paint: fg),
    mark: (end: "straight", scale: 0.4),
  )

  // ── Six layer blocks ──────────────────────────────────
  for i in range(n) {
    let (num, name, rejects, is-novel) = layers.at(i)

    let y-top = stack-top-y - i * (bh + gap)
    let y-bot = y-top - bh
    let y-mid = (y-top + y-bot) / 2

    let stroke-c = if is-novel { accent } else { border }
    let fill-c   = if is-novel { accent.lighten(92%) } else { white }
    let stroke-w = if is-novel { 1.4pt } else { 0.9pt }
    let txt-c    = if is-novel { accent.darken(20%) } else { fg }

    rect(
      (-bw / 2, y-bot),
      ( bw / 2, y-top),
      radius: 4pt,
      fill: fill-c,
      stroke: (thickness: stroke-w, paint: stroke-c),
      name: "L" + str(i),
    )

    // Layer number — left side, monospaced
    content(
      (-bw / 2 + 0.4, y-mid), anchor: "west",
      text(8pt, weight: "bold", fill: txt-c.lighten(20%),
        font: "DejaVu Sans Mono", str(num)),
    )

    // Vertical separator after the number
    line(
      (-bw / 2 + 0.75, y-top - 0.12),
      (-bw / 2 + 0.75, y-bot + 0.12),
      stroke: (thickness: 0.5pt, paint: stroke-c.lighten(40%)),
    )

    // Layer name — left-anchored after the separator
    content(
      (-bw / 2 + 0.95, y-mid), anchor: "west",
      text(9pt, weight: "bold", fill: txt-c, name),
    )

    // novel-layer badge on the right (inside the block)
    if is-novel {
      content(
        (bw / 2 - 0.35, y-mid), anchor: "east",
        text(7pt, weight: "bold", fill: accent,
          [#sym.star this work]),
      )
    }

    // "rejects:" annotation outside, to the right
    content(
      (rejects-x, y-mid), anchor: "west",
      text(7pt, fill: fg-light, style: "italic",
        [rejects #rejects]),
    )

    // arrow from this block to the next (or to output cap)
    if i < n - 1 {
      let next-top = y-bot - gap
      line(
        (0, y-bot - 0.04),
        (0, next-top + 0.04),
        stroke: (thickness: 0.7pt, paint: fg-light),
        mark: (end: "straight", scale: 0.3),
      )
    }
  }

  // ── Bottom cap: output ────────────────────────────────
  let cap-bot-y = stack-bot-y - 0.7
  rect(
    (-cap-w / 2, cap-bot-y - cap-h),
    ( cap-w / 2, cap-bot-y),
    radius: cap-h / 2,
    fill: accent.lighten(92%),
    stroke: (thickness: 1.3pt, paint: accent),
    name: "output",
  )
  content(
    "output", anchor: "center",
    text(8.5pt, weight: "bold", fill: accent.darken(20%))[Verified library entry],
  )

  // arrow from last block into output
  line(
    (0, stack-bot-y - 0.04),
    (0, cap-bot-y + 0.04),
    stroke: (thickness: 1pt, paint: accent),
    mark: (end: "straight", scale: 0.4),
  )

})
