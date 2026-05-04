#import "lib.typ": *

#set page(..fig-page)
#set text(..fig-text)

#canvas(length: 0.40cm, {
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
      name-id,
      anchor: "center",
      box(width: w * 0.40cm - 8pt, align(center, body)),
    )
  }

  // Neutral box (default)
  let nbox(cx, cy, w, h, name-id, body) = box-base(
    cx, cy, w, h, name-id,
    fill-light, (thickness: 0.9pt, paint: border),
    body,
  )

  // Accent box: highlight the single source of truth
  let abox(cx, cy, w, h, name-id, body) = box-base(
    cx, cy, w, h, name-id,
    accent.lighten(85%), (thickness: 1.3pt, paint: accent),
    body,
  )

  // ── Arrow style ──────────────────────────────────────────
  let s-edge   = (thickness: 0.85pt, paint: edge-col)
  let s-loop   = (thickness: 0.85pt, paint: accent, dash: "dashed")
  let arr      = (end: "straight", scale: 0.35)
  let sh       = (start: 0.06, end: 0.06)

  // ── Arrow label helper (above midpoint, with white halo) ──
  let elabel(name-id, dy, txt) = content(
    (rel: (0, dy), to: name-id + ".mid"), anchor: "south",
    text(5.5pt, fill: fg-light)[#txt],
  )

  // ── Layout (5 columns × 2 rows) ─────────────────────────
  let bw = 6.0
  let bh = 2.2
  let sw = 5.6
  let sh-box = 1.7

  let cx-issue  =  0.0
  let cx-core   =  8.5
  let cx-art    = 16.5    // JSON (top) and CLI (bot)
  let cx-pdf    = 24.5    // PDF Manual (top only)
  let cx-verify = 32.5

  let y-mid =  0.0
  let y-top =  2.6
  let y-bot = -2.6

  // ── Boxes ────────────────────────────────────────────────
  // Input
  nbox(cx-issue, y-mid, bw, bh, "issue", [
    #text(8pt, weight: "bold")[GitHub Issue] \
    #v(-0.2em)
    #text(6pt, fill: fg-light)[definition · example · solution]
  ])

  // Single source of truth (accent)
  abox(cx-core, y-mid, bw, bh, "core", [
    #text(8pt, weight: "bold", fill: accent.darken(20%))[Example Database] \
    #v(-0.2em)
    #text(6pt, fill: accent.darken(10%))[canonical builders]
  ])

  // JSON Fixtures (top, upstream of PDF manual)
  nbox(cx-art, y-top, sw, sh-box, "json", [
    #text(7.5pt, weight: "bold")[JSON Fixtures] \
    #v(-0.2em)
    #text(5.5pt, fill: fg-light)[ground-truth I/O]
  ])

  // CLI (bottom, parallel branch from DB)
  nbox(cx-art, y-bot, sw, sh-box, "cli", [
    #text(7.5pt, weight: "bold")[#raw("pred --example")] \
    #v(-0.2em)
    #text(5.5pt, fill: fg-light)[interactive demo]
  ])

  // Typst PDF Manual (rendered from JSON)
  nbox(cx-pdf, y-top, sw, sh-box, "pdf", [
    #text(7.5pt, weight: "bold")[Typst PDF Manual] \
    #v(-0.2em)
    #text(5.5pt, fill: fg-light)[diagrams · proofs]
  ])

  // Verification (Stage 6)
  nbox(cx-verify, y-mid, bw, bh, "verify", [
    #text(8pt, weight: "bold")[Verification] \
    #v(-0.2em)
    #text(6pt, fill: fg-light)[stage 6 · contributor review]
  ])

  // ── Forward arrows ───────────────────────────────────────
  // Issue → Core
  line("issue.east", "core.west",
    stroke: s-edge, mark: arr, shorten: sh, name: "e-extract")
  elabel("e-extract", 0.35, [extract])

  // Core → JSON (orthogonal up)
  let fork = (cx-core + cx-art) / 2
  line("core.east", (fork, y-mid), (fork, y-top), "json.west",
    stroke: s-edge, mark: arr, shorten: sh, name: "e-gen-json")
  // Core → CLI (orthogonal down)
  line("core.east", (fork, y-mid), (fork, y-bot), "cli.west",
    stroke: s-edge, mark: arr, shorten: sh)
  // single "generate" label sits in the fork gutter
  content((fork, y-mid + 0.25), anchor: "south",
    text(5.5pt, fill: fg-light)[generate])

  // JSON → PDF Manual (top branch, horizontal: render)
  line("json.east", "pdf.west",
    stroke: s-edge, mark: arr, shorten: sh, name: "e-render")
  elabel("e-render", 0.35, [render])

  // PDF → Verify (top, orthogonal down)
  let merge = (cx-pdf + cx-verify) / 2
  line("pdf.east", (merge, y-top), (merge, y-mid), "verify.west",
    stroke: s-edge, mark: arr, shorten: sh)
  // CLI → Verify (bottom, orthogonal up)
  line("cli.east", (merge, y-bot), (merge, y-mid), "verify.west",
    stroke: s-edge, mark: arr, shorten: sh)
  content((merge, y-mid + 0.25), anchor: "south",
    text(5.5pt, fill: fg-light)[contributor compares])

  // ── Closing the loop ────────────────────────────────────
  // Dashed accent arrow from Verification back to Issue
  let loop-y = y-bot - 1.6
  line(
    "verify.south",
    (cx-verify, loop-y),
    (cx-issue,  loop-y),
    "issue.south",
    stroke: s-loop,
    mark: arr,
  )
  content(
    ((cx-issue + cx-verify) / 2, loop-y - 0.35),
    anchor: "north",
    text(5.5pt, fill: accent.darken(10%), style: "italic")[
      Stage 6: any drift from the original issue surfaces here
    ],
  )
})
