#import "lib.typ": *

#set page(..fig-page)
#set text(..fig-text)

// ── Layer data: (number, name, runner, what it rejects, concrete example, novel?) ──
#let layers = (
  (1, "Issue review",
     "LLM agent",
     "vague specs, unsupported claims",
     [issue uses parameter $k$ but never defines it],
     false),
  (2, "Compile-time type checks",
     "Rust compiler",
     "API misuse, type errors",
     raw("trait Problem not satisfied for Foo"),
     false),
  (3, "Unit tests",
     "CI",
     "evaluation and serialization bugs",
     raw("assert eval(0,1) == 2 — failed"),
     false),
  (4, "Round-trip tests",
     "CI",
     "drift between contributor's example and the artifact",
     [JSON fixture's target $!=$ PDF manual's diagram],
     true),
  (5, "Agentic feature tests",
     "LLM agent (fresh context)",
     "usability and semantic errors at the CLI surface",
     [persona expected `pred solve` to print the cut; CLI prints nothing],
     true),
  (6, "Manual verification",
     "Contributor",
     "subtle misinterpretations of the original math",
     [reduction direction reversed: $A arrow.r B$ implemented as $B arrow.r A$],
     false),
)

#canvas(length: 1cm, {
  import draw: *

  // Layout
  let bw = 7.6       // block width (cm units, since length=1cm)
  let bh = 1.05      // block height (taller to fit example line)
  let gap = 0.30     // vertical gap between blocks
  let cap-w = 5.0
  let cap-h = 0.85
  let rejects-x = bw / 2 + 0.4   // x for right-side "rejects: ..." labels

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
    let (num, name, runner, rejects, example, is-novel) = layers.at(i)

    let y-top = stack-top-y - i * (bh + gap)
    let y-bot = y-top - bh
    let y-mid = (y-top + y-bot) / 2
    let y-name   = y-mid + 0.22  // upper text row inside block
    let y-runner = y-mid - 0.27  // lower text row inside block

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
      text(10pt, weight: "bold", fill: txt-c.lighten(15%),
        font: "DejaVu Sans Mono", str(num)),
    )

    // Vertical separator after the number
    line(
      (-bw / 2 + 0.85, y-top - 0.18),
      (-bw / 2 + 0.85, y-bot + 0.18),
      stroke: (thickness: 0.5pt, paint: stroke-c.lighten(40%)),
    )

    // Layer name (upper row inside block)
    content(
      (-bw / 2 + 1.0, y-name), anchor: "west",
      text(9pt, weight: "bold", fill: txt-c, name),
    )

    // Runner tag (lower row inside block, smaller)
    content(
      (-bw / 2 + 1.0, y-runner), anchor: "west",
      text(6.5pt, fill: txt-c.lighten(30%))[
        run by · #runner
      ],
    )

    // novel-layer badge (upper-right, inside block)
    if is-novel {
      content(
        (bw / 2 - 0.35, y-name), anchor: "east",
        text(7pt, weight: "bold", fill: accent,
          [#sym.star this work]),
      )
    }

    // ── Right-side annotations (outside block) ──
    // "rejects: ..." (upper)
    content(
      (rejects-x, y-name), anchor: "west",
      text(7pt, fill: fg-light)[
        #text(weight: "bold", fill: fg)[rejects:] #rejects
      ],
    )

    // "e.g., ..." concrete example (lower, italic monospace-ish)
    content(
      (rejects-x, y-runner), anchor: "west",
      text(6.5pt, fill: fg-light, style: "italic")[
        e.g., #example
      ],
    )

    // arrow from this block to the next
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
