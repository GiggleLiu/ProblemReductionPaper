#import "lib.typ": *

#set page(..fig-page)
#set text(..fig-text)

#canvas(length: 0.48cm, {
  import draw: *

  // ── Palette ──
  let col-input  = rgb("#4e79a7")   // blue — input
  let col-core   = rgb("#59a14f")   // green — core
  let col-output = rgb("#e8a838")   // gold — output artifacts
  let col-verify = rgb("#e15759")   // red — verification

  // ── Helpers ──
  let rbox(pos, w, h, col, name-id, title, ..details) = {
    rect(
      pos, (pos.at(0) + w, pos.at(1) - h),
      radius: 4pt,
      fill: col.lighten(80%),
      stroke: (thickness: 1.2pt, paint: col.darken(10%)),
      name: name-id,
    )
    let body = {
      text(7.5pt, weight: "bold", fill: black, title)
      for d in details.pos() {
        linebreak()
        text(6pt, fill: black, d)
      }
    }
    content(name-id, anchor: "center", body)
  }

  let arr = (end: "straight", scale: 0.35)
  let s = (thickness: 1pt, paint: black)
  let sh = (start: 0.08, end: 0.08)

  // ── Layout ──
  let bw = 7.0
  let bh = 2.2
  let bh-s = 1.8
  let cx = 8.0

  // ── Row 1: Source instance (from example DB) ──
  let y1 = 0
  rbox((cx - bw / 2, y1), bw, bh, col-input, "source",
    [Source Instance],
    [from example database],
    [known optimal value])

  // ── Row 2: Forward map ──
  let y2 = y1 - bh - 1.8
  rbox((cx - bw / 2, y2), bw, bh, col-core, "target",
    [Target Instance],
    [via `reduce_to()`])

  // Arrow: Source → Target
  line("source.south", "target.north",
    stroke: s, mark: arr, shorten: sh, name: "e1")
  content((rel: (0.6, 0), to: "e1.mid"), anchor: "west",
    text(6pt, fill: black, [forward map]))

  // ── Row 3: Solve + extract ──
  let y3 = y2 - bh - 1.8
  rbox((cx - bw / 2, y3), bw, bh, col-output, "solution",
    [Recovered Source Solution],
    [solve target, then `extract_solution()`])

  // Arrow: Target → Solution
  line("target.south", "solution.north",
    stroke: s, mark: arr, shorten: sh, name: "e2")
  content((rel: (0.6, 0), to: "e2.mid"), anchor: "west",
    text(6pt, fill: black, [solve + inverse map]))

  // ── Verify: loop back to source ──
  let fb-x = cx - bw / 2 - 2.5
  let source-mid-y = y1 - bh / 2
  let sol-mid-y = y3 - bh / 2

  line(
    (cx - bw / 2, sol-mid-y),
    (fb-x, sol-mid-y),
    (fb-x, source-mid-y),
    (cx - bw / 2, source-mid-y),
    stroke: (thickness: 1.2pt, paint: col-verify),
    mark: (end: "straight", scale: 0.35),
  )
  content(
    (fb-x - 0.3, (source-mid-y + sol-mid-y) / 2),
    anchor: "east",
    text(6.5pt, fill: col-verify,
      align(center, [evaluate &\
        check optimality])),
  )
})
