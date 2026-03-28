#import "lib.typ": *

#set page(..fig-page)
#set text(..fig-text)

#let scale = 0.65cm

#canvas(length: scale, {
  import draw: *

  // ── Palette ──
  let col-trait   = rgb("#4e79a7")
  let col-reduce  = rgb("#59a14f")
  let col-compile = rgb("#e8a838")

  // ── Layout ──
  let bw = 14.0
  let cx = 0.0
  let gap = 1.2

  // ── Helper: typst block inside cetz content() ──
  let tbox(pos, w, h, col, name-id, body) = {
    rect(
      pos, (pos.at(0) + w, pos.at(1) - h),
      radius: 4pt,
      fill: col.lighten(85%),
      stroke: (thickness: 1.2pt, paint: col.darken(10%)),
      name: name-id,
    )
    content(
      name-id, anchor: "center",
      box(width: w * scale - 16pt, body),
    )
  }

  // ═══════════════════════════════════════
  // Box 1: Problem trait + aggregate wrappers
  // ═══════════════════════════════════════
  let y1 = 0
  let box1-h = 3.6
  tbox((cx - bw/2, y1), bw, box1-h, col-trait, "box1")[
    #set align(center)
    #text(9pt, weight: "bold")[`Problem` trait]
    #v(3pt)
    #text(7.5pt, fill: fg-light)[
      `NAME` #sym.dot.c `Value: Aggregate` #sym.dot.c `dims()` #sym.dot.c `evaluate()`
    ]
    #v(3pt)
    #std.line(length: 100%, stroke: 0.5pt + col-trait.lighten(40%))
    #v(4pt)
    #std.grid(
      columns: (1fr,) * 5,
      gutter: 4pt,
      ..{
        let wrappers = (
          (`Max<W>`, [NP opt.]),
          (`Min<W>`, [NP opt.]),
          (`Or`, [NP dec.]),
          (`And`, [co-NP]),
          (`Sum<W>`, [\#P]),
        )
        wrappers.map(((name, label)) =>
          std.rect(
            width: 100%,
            radius: 3pt,
            fill: col-trait.lighten(78%),
            stroke: 0.8pt + col-trait.darken(10%),
            inset: (x: 2pt, y: 4pt),
            align(center)[
              #text(7.5pt, weight: "bold", name) \
              #text(6pt, fill: fg-light, label)
            ],
          )
        )
      },
    )
  ]

  // ═══════════════════════════════════════
  // Arrow 1: ReduceTo<T>
  // ═══════════════════════════════════════
  let a1-top = y1 - box1-h
  let a1-bot = a1-top - gap
  line(
    (cx, a1-top), (cx, a1-bot + 0.05),
    stroke: 1pt + col-reduce.darken(10%),
    mark: (end: "straight", scale: 0.4),
  )
  content(
    (cx + 0.3, (a1-top + a1-bot) / 2), anchor: "west",
    text(8pt, weight: "bold", fill: col-reduce.darken(10%), [`ReduceTo<T>`]),
  )

  // ═══════════════════════════════════════
  // Box 2: ReductionResult
  // ═══════════════════════════════════════
  let box2-h = 1.5
  let y2 = a1-bot
  tbox((cx - bw/2, y2), bw, box2-h, col-reduce, "box2")[
    #set align(center)
    #text(9pt, weight: "bold")[`ReductionResult<T>`]
    #v(3pt)
    #text(7.5pt, fill: fg-light)[
      `target_problem()` #sym.dot.c `extract_solution()`
    ]
  ]

  // ═══════════════════════════════════════
  // Arrow 2: #[reduction(overhead)]
  // ═══════════════════════════════════════
  let a2-top = y2 - box2-h
  let a2-bot = a2-top - gap
  line(
    (cx, a2-top), (cx, a2-bot + 0.05),
    stroke: 1pt + col-compile.darken(10%),
    mark: (end: "straight", scale: 0.4),
  )
  content(
    (cx + 0.3, (a2-top + a2-bot) / 2), anchor: "west",
    text(7.5pt, fill: col-compile.darken(10%), [`\#[reduction(overhead = {...})]`]),
  )

  // ═══════════════════════════════════════
  // Box 3: Compile-time validation
  // ═══════════════════════════════════════
  let box3-h = 2.2
  let y3 = a2-bot
  tbox((cx - bw/2, y3), bw, box3-h, col-compile, "box3")[
    #text(9pt, weight: "bold")[Compile-time validation]
    #v(4pt)
    #text(7.5pt, fill: fg-light)[
      #sym.bullet Variable names #sym.arrow getter methods \
      #sym.bullet `Expr` AST: symbolic overhead expressions \
      #sym.bullet `declare_variants!` #sym.arrow compile-time registry
    ]
  ]
})
