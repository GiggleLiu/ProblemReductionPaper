#import "lib.typ": *

#set page(..fig-page)
#set text(..fig-text)

#canvas(length: 0.48cm, {
  import draw: *

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
  let bw = 7.5
  let bh = 2.0
  let gap = 2.0

  // ── Row 1: Source problem instance ──
  let y1 = 0
  let cx = 8.0
  rbox((cx - bw / 2, y1), bw, bh, accent, "source",
    [Source Instance],
    [e.g.\ 3-SAT formula from example DB])

  // ── Row 2: Reduce ──
  let y2 = y1 - bh - gap
  rbox((cx - bw / 2, y2), bw, bh, rgb("#59a14f"), "target",
    [Target Instance],
    [e.g.\ MIS graph via `reduce_to()`])

  // Arrow: Source → Target
  line("source.south", "target.north",
    stroke: s, mark: arr, shorten: sh, name: "e-reduce")
  content((rel: (0.6, 0), to: "e-reduce.mid"), anchor: "west",
    text(6pt, fill: black, [forward map]))

  // ── Row 3: Solve target ──
  let y3 = y2 - bh - gap
  rbox((cx - bw / 2, y3), bw, bh, rgb("#e8a838"), "target-sol",
    [Target Solution],
    [brute-force or ILP solver])

  // Arrow: Target → Target Solution
  line("target.south", "target-sol.north",
    stroke: s, mark: arr, shorten: sh, name: "e-solve")
  content((rel: (0.6, 0), to: "e-solve.mid"), anchor: "west",
    text(6pt, fill: black, [solve]))

  // ── Row 4: Extract source solution ──
  let y4 = y3 - bh - gap
  rbox((cx - bw / 2, y4), bw, bh, rgb("#e8a838"), "source-sol",
    [Source Solution],
    [via `extract_solution()`])

  // Arrow: Target Solution → Source Solution
  line("target-sol.south", "source-sol.north",
    stroke: s, mark: arr, shorten: sh, name: "e-extract")
  content((rel: (0.6, 0), to: "e-extract.mid"), anchor: "west",
    text(6pt, fill: black, [inverse map]))

  // ── Verify: loop back to source ──
  let fb-x = cx - bw / 2 - 2.5
  let source-mid-y = y1 - bh / 2
  let sol-mid-y = y4 - bh / 2

  line(
    (cx - bw / 2, sol-mid-y),
    (fb-x, sol-mid-y),
    (fb-x, source-mid-y),
    (cx - bw / 2, source-mid-y),
    stroke: (thickness: 1pt, paint: rgb("#e15759")),
    mark: (end: "straight", scale: 0.35),
  )
  content(
    (fb-x - 0.3, (source-mid-y + sol-mid-y) / 2),
    anchor: "east",
    text(6.5pt, fill: rgb("#e15759"),
      align(center, [evaluate &\
        check optimality])),
  )
})
