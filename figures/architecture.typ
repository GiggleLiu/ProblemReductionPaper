#import "lib.typ": *

#set page(..fig-page)
#set text(..fig-text)

#canvas(length: 0.48cm, {
  import draw: *

  // ── Palette (matches library-architecture.typ) ──
  let col-trait    = rgb("#4e79a7")   // blue — traits
  let col-reduce   = rgb("#59a14f")   // green — reductions
  let col-compile  = rgb("#e8a838")   // gold — compile-time

  // ── Helpers ──
  let rbox(pos, w, h, col, name-id, title, ..details) = {
    rect(
      pos, (pos.at(0) + w, pos.at(1) - h),
      radius: 4pt,
      fill: col.lighten(85%),
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

  let arr = arrow-end
  let s = stroke-edge
  let sh = (start: 0.08, end: 0.08)

  // ── Layout ──
  let bw = 12.0
  let cx = 0.0

  // ═══════════════════════════════════════
  // Box 1: Problem trait + aggregate wrappers
  // ═══════════════════════════════════════
  let y1 = 0
  let box1-h = 3.0
  rect(
    (cx - bw/2, y1), (cx + bw/2, y1 - box1-h),
    radius: 4pt,
    fill: col-trait.lighten(85%),
    stroke: (thickness: 1.2pt, paint: col-trait.darken(10%)),
    name: "box1",
  )

  // Title + methods
  content(
    (cx, y1 - 0.4), anchor: "center",
    text(8pt, weight: "bold", fill: black, [`Problem` trait]),
  )
  content(
    (cx, y1 - 0.95), anchor: "center",
    text(6.5pt, fill: fg-light,
      [`NAME` #sym.dot.c `Value: Aggregate` #sym.dot.c `dims()` #sym.dot.c `evaluate()`]),
  )

  // Divider
  line(
    (cx - bw/2 + 0.4, y1 - 1.3),
    (cx + bw/2 - 0.4, y1 - 1.3),
    stroke: (thickness: 0.5pt, paint: col-trait.lighten(40%)),
  )

  // Aggregate wrapper sub-boxes
  let sub-m = 0.35
  let sub-gap = 0.25
  let n = 5
  let sub-w = (bw - 2*sub-m - (n - 1)*sub-gap) / n
  let sub-h = 0.9
  let sub-y = y1 - 1.55

  let wrappers = (
    (`Max<W>`, [NP opt.]),
    (`Min<W>`, [NP opt.]),
    (`Or`, [NP dec.]),
    (`Sum<W>`, [\#P]),
    (`And`, [co-NP]),
  )

  for (i, (name, label)) in wrappers.enumerate() {
    let xl = cx - bw/2 + sub-m + i * (sub-w + sub-gap)
    let id = "agg" + str(i)
    rect(
      (xl, sub-y), (xl + sub-w, sub-y - sub-h),
      radius: 3pt,
      fill: col-trait.lighten(78%),
      stroke: (thickness: 0.8pt, paint: col-trait.darken(10%)),
      name: id,
    )
    content(id, anchor: "center", {
      text(6.5pt, weight: "bold", fill: black, name)
      linebreak()
      text(5.5pt, fill: fg-light, label)
    })
  }

  // ═══════════════════════════════════════
  // Arrow 1 + label: ReduceTo<T>
  // ═══════════════════════════════════════
  let gap = 1.4
  let a1-top = y1 - box1-h
  let a1-bot = a1-top - gap
  line(
    (cx, a1-top), (cx, a1-bot + 0.05),
    stroke: (thickness: 1pt, paint: col-reduce.darken(10%)),
    mark: (end: "straight", scale: 0.4),
  )
  content(
    (cx + 0.3, (a1-top + a1-bot) / 2), anchor: "west",
    text(7.5pt, weight: "bold", fill: col-reduce.darken(10%), [`ReduceTo<T>`]),
  )

  // ═══════════════════════════════════════
  // Box 2: ReductionResult
  // ═══════════════════════════════════════
  let box2-h = 1.6
  let y2 = a1-bot
  rbox(
    (cx - bw/2, y2), bw, box2-h, col-reduce, "box2",
    [`ReductionResult<T>`],
    [`target_problem()` #sym.dot.c `extract_solution()`],
  )

  // ═══════════════════════════════════════
  // Arrow 2 + label: #[reduction(overhead)]
  // ═══════════════════════════════════════
  let a2-top = y2 - box2-h
  let a2-bot = a2-top - gap
  line(
    (cx, a2-top), (cx, a2-bot + 0.05),
    stroke: (thickness: 1pt, paint: col-compile.darken(10%)),
    mark: (end: "straight", scale: 0.4),
  )
  content(
    (cx + 0.3, (a2-top + a2-bot) / 2), anchor: "west",
    text(7pt, fill: col-compile.darken(10%), [`\#[reduction(overhead = {...})]`]),
  )

  // ═══════════════════════════════════════
  // Box 3: Compile-time validation
  // ═══════════════════════════════════════
  let box3-h = 2.4
  let y3 = a2-bot
  rect(
    (cx - bw/2, y3), (cx + bw/2, y3 - box3-h),
    radius: 4pt,
    fill: col-compile.lighten(85%),
    stroke: (thickness: 1.2pt, paint: col-compile.darken(10%)),
    name: "box3",
  )

  content(
    (cx, y3 - 0.45), anchor: "center",
    text(8pt, weight: "bold", fill: black, [Compile-time validation]),
  )

  let bx = cx - bw/2 + 1.2
  let by = y3 - 1.1
  for (i, item) in (
    [Variable names #sym.arrow getter methods],
    [`Expr` AST: symbolic overhead expressions],
    [`declare_variants!` #sym.arrow compile-time registry],
  ).enumerate() {
    content(
      (bx, by - i * 0.55), anchor: "west",
      text(6.5pt, fill: fg-light, [#sym.bullet #h(2pt) #item]),
    )
  }
})
