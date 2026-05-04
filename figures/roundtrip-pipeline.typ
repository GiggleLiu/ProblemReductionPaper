#import "lib.typ": *

#set page(..fig-page)
#set text(..fig-text)

#let unit-len = 0.40cm

#canvas(length: unit-len, {
  import draw: *

  // ── Box helpers ──────────────────────────────────────────
  let box-base(cx, cy, w, h, name-id, fill-c, stroke-c, body) = {
    rect(
      (cx - w / 2, cy - h / 2),
      (cx + w / 2, cy + h / 2),
      radius: 3pt,
      fill: fill-c,
      stroke: stroke-c,
      name: name-id,
    )
    content(
      name-id, anchor: "center",
      box(width: w * unit-len - 10pt, align(center, body)),
    )
  }

  let nbox(cx, cy, w, h, id, body) = box-base(
    cx, cy, w, h, id,
    fill-light, (thickness: 0.9pt, paint: border), body,
  )
  let abox(cx, cy, w, h, id, body) = box-base(
    cx, cy, w, h, id,
    accent.lighten(85%), (thickness: 1.3pt, paint: accent), body,
  )

  // ── Arrow style ──────────────────────────────────────────
  let s-edge = (thickness: 0.85pt, paint: edge-col)
  let s-loop = (thickness: 1.0pt,  paint: accent, dash: "dashed")
  let arr    = (end: "straight", scale: 0.35)
  let sh     = (start: 0.06, end: 0.06)

  // ── Layout ───────────────────────────────────────────────
  let bw = 8.0
  let bh = 2.6
  let sw = 6.6
  let sh-box = 1.7

  let cx-input  =  0.0
  let cx-core   =  9.8
  let cx-art1   = 18.4   // JSON top / CLI bot
  let cx-art2   = 26.6   // PDF top
  let cx-review = 35.4

  let y-mid =  0.0
  let y-top =  2.6
  let y-bot = -2.6

  // ── Boxes ────────────────────────────────────────────────
  nbox(cx-input, y-mid, bw, bh, "input", [
    #text(7.5pt, weight: "bold")[Contributor's worked example] \
    #v(-0.15em)
    #text(5.5pt, fill: fg-light)[a concrete instance with a \
    pre-computed correct answer]
  ])

  abox(cx-core, y-mid, bw, bh, "core", [
    #text(7.5pt, weight: "bold", fill: accent.darken(20%))[
      Canonical builder
    ] \
    #v(-0.15em)
    #text(5.5pt, fill: accent.darken(10%))[
      encodes the example as code; \
      *single source of truth*
    ]
  ])

  nbox(cx-art1, y-top, sw, sh-box, "json", [
    #text(7pt, weight: "bold")[JSON fixture] \
    #v(-0.15em)
    #text(5pt, fill: fg-light)[ground-truth I/O]
  ])

  nbox(cx-art1, y-bot, sw, sh-box, "cli", [
    #text(7pt, weight: "bold")[#raw("pred --example")] \
    #v(-0.15em)
    #text(5pt, fill: fg-light)[interactive demo]
  ])

  nbox(cx-art2, y-top, sw, sh-box, "pdf", [
    #text(7pt, weight: "bold")[PDF manual] \
    #v(-0.15em)
    #text(5pt, fill: fg-light)[diagram + proof]
  ])

  nbox(cx-review, y-mid, bw, bh, "review", [
    #text(7.5pt, weight: "bold")[Contributor checks] \
    #v(-0.15em)
    #text(5.5pt, fill: fg-light, style: "italic")[
      "does every artifact still \
      match the example I gave?"
    ]
  ])

  // ── Forward arrows ──────────────────────────────────────
  // Input → Core
  line("input.east", "core.west",
    stroke: s-edge, mark: arr, shorten: sh, name: "e-codify")
  content((rel: (0, 0.35), to: "e-codify.mid"), anchor: "south",
    text(5.5pt, fill: fg-light)[codified as Rust function])

  // Core → JSON (top), Core → CLI (bot) — orthogonal fork
  let fork = (cx-core + cx-art1) / 2
  line("core.east", (fork, y-mid), (fork, y-top), "json.west",
    stroke: s-edge, mark: arr, shorten: sh)
  line("core.east", (fork, y-mid), (fork, y-bot), "cli.west",
    stroke: s-edge, mark: arr, shorten: sh)
  content((fork, y-mid + 0.3), anchor: "south",
    text(5.5pt, fill: fg-light)[auto-generates])

  // JSON → PDF (top horizontal)
  line("json.east", "pdf.west",
    stroke: s-edge, mark: arr, shorten: sh, name: "e-render")
  content((rel: (0, 0.3), to: "e-render.mid"), anchor: "south",
    text(5.5pt, fill: fg-light)[rendered into])

  // PDF → Review (top), CLI → Review (bot) — orthogonal merge
  let merge = (cx-art2 + cx-review) / 2
  line("pdf.east", (merge, y-top), (merge, y-mid), "review.west",
    stroke: s-edge, mark: arr, shorten: sh)
  line("cli.east", (merge, y-bot), (merge, y-mid), "review.west",
    stroke: s-edge, mark: arr, shorten: sh)
  content((merge, y-mid + 0.3), anchor: "south",
    text(5.5pt, fill: fg-light)[seen by contributor])

  // ── Closing the loop ────────────────────────────────────
  let loop-y = y-bot - 1.8
  line(
    "review.south",
    (cx-review, loop-y),
    (cx-input,  loop-y),
    "input.south",
    stroke: s-loop,
    mark: arr,
  )
  content(
    ((cx-input + cx-review) / 2, loop-y - 0.4),
    anchor: "north",
    text(6pt, fill: accent.darken(10%), weight: "bold")[
      ROUND-TRIP TEST
    ],
  )
  content(
    ((cx-input + cx-review) / 2, loop-y - 1.05),
    anchor: "north",
    text(5.5pt, fill: fg-light, style: "italic")[
      any divergence between an artifact and the original example reveals a pipeline bug
    ],
  )
})
