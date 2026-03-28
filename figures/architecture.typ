#import "lib.typ": *

#set page(..fig-page)
#set text(..fig-text)

// ── Palette ──
#let col-trait   = rgb("#4e79a7")
#let col-reduce  = rgb("#59a14f")
#let col-compile = rgb("#e8a838")

// ── Shared box width ──
#let W = 220pt

// ── Styled box helper ──
#let sbox(col, body) = rect(
  width: W,
  radius: 4pt,
  fill: col.lighten(85%),
  stroke: (thickness: 1.2pt, paint: col.darken(10%)),
  inset: (x: 8pt, y: 6pt),
  body,
)

// ── Arrow helper ──
#let arrow-label(col, label) = {
  v(2pt)
  align(center,
    stack(dir: ltr, spacing: 6pt,
      // vertical arrow
      box(width: 0pt, height: 18pt,
        place(center + horizon,
          line(length: 18pt, angle: 90deg, stroke: 1pt + col.darken(10%)),
        ),
      ),
      // arrowhead at bottom
      text(7.5pt, weight: "bold", fill: col.darken(10%), label),
    ),
  )
  v(2pt)
}

// ═══════════════════════════════════════
// Box 1: Problem trait + aggregate wrappers
// ═══════════════════════════════════════
#sbox(col-trait)[
  #align(center)[
    #text(8pt, weight: "bold")[`Problem` trait] \
    #v(2pt)
    #text(6.5pt, fill: fg-light)[
      `NAME` #sym.dot.c `Value: Aggregate` #sym.dot.c `dims()` #sym.dot.c `evaluate()`
    ]
  ]
  #v(3pt)
  #line(length: 100%, stroke: 0.5pt + col-trait.lighten(40%))
  #v(3pt)
  #grid(
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
        rect(
          width: 100%,
          radius: 3pt,
          fill: col-trait.lighten(78%),
          stroke: 0.8pt + col-trait.darken(10%),
          inset: (x: 2pt, y: 4pt),
          align(center)[
            #text(6.5pt, weight: "bold", name) \
            #text(5.5pt, fill: fg-light, label)
          ],
        )
      )
    },
  )
]

// ═══════════════════════════════════════
// Arrow 1: ReduceTo<T>
// ═══════════════════════════════════════
#arrow-label(col-reduce, [`ReduceTo<T>`])

// ═══════════════════════════════════════
// Box 2: ReductionResult
// ═══════════════════════════════════════
#sbox(col-reduce)[
  #align(center)[
    #text(8pt, weight: "bold")[`ReductionResult<T>`] \
    #v(2pt)
    #text(6.5pt, fill: fg-light)[
      `target_problem()` #sym.dot.c `extract_solution()`
    ]
  ]
]

// ═══════════════════════════════════════
// Arrow 2: #[reduction(overhead)]
// ═══════════════════════════════════════
#arrow-label(col-compile, [`\#[reduction(overhead = {...})]`])

// ═══════════════════════════════════════
// Box 3: Compile-time validation
// ═══════════════════════════════════════
#sbox(col-compile)[
  #text(8pt, weight: "bold")[Compile-time validation]
  #v(3pt)
  #text(6.5pt, fill: fg-light)[
    #sym.bullet Variable names #sym.arrow getter methods \
    #sym.bullet `Expr` AST: symbolic overhead expressions \
    #sym.bullet `declare_variants!` #sym.arrow compile-time registry
  ]
]
