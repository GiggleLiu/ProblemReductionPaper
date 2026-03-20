#import "lib.typ": *

#set page(..fig-page)
#set text(..fig-text)

#canvas(length: 0.50cm, {
  import draw: *

  // ── Palette ──
  let col-cli     = rgb("#4e79a7")   // blue — CLI / user-facing
  let col-core    = rgb("#59a14f")   // green — core library
  let col-macro   = rgb("#e8a838")   // gold — compile-time
  let col-ext     = luma(140)        // gray — external

  // ── Helpers ──
  let rounded-box(pos, w, h, col, name-id) = {
    rect(
      pos, (pos.at(0) + w, pos.at(1) - h),
      radius: 4pt,
      fill: col.lighten(90%),
      stroke: (thickness: 1pt, paint: col),
      name: name-id,
    )
  }

  let inner-box(pos, w, h, col, name-id, title, detail) = {
    rect(
      pos, (pos.at(0) + w, pos.at(1) - h),
      radius: 3pt,
      fill: col.lighten(80%),
      stroke: (thickness: 0.6pt, paint: col.lighten(20%)),
      name: name-id,
    )
    content(name-id, anchor: "center", {
      text(7pt, weight: "bold", fill: col.darken(10%), title)
      if detail != none {
        linebreak()
        text(5.5pt, fill: luma(90), detail)
      }
    })
  }

  let section-label(pos, col, label) = {
    content(pos, anchor: "west",
      text(8pt, weight: "bold", fill: col.darken(20%), label))
  }

  // ── Layout constants ──
  let total-w = 18.0
  let col-w = 3.8       // inner box width
  let col-h = 2.0       // inner box height
  let gap = 0.4         // gap between inner boxes
  let margin = 0.5      // padding inside outer box

  // ══════════════════════════════════════════
  // Layer 1: User Interfaces (top)
  // ══════════════════════════════════════════
  let y1 = 0
  let cli-h = 2.8
  rounded-box((0, y1), total-w, cli-h, col-cli, "cli-box")
  section-label((margin, y1 - 0.4), col-cli, [User Interfaces])

  // CLI box
  let ui-y = y1 - 1.0
  inner-box((margin, ui-y), 5.4, 1.5, col-cli, "cli",
    [`pred` CLI],
    [`create` · `path` · `solve` · `reduce` · `list`])

  // Library API box
  inner-box((margin + 5.4 + gap, ui-y), 5.4, 1.5, col-cli, "api",
    [Library API],
    [Rust crate: `use problemreductions::*`])

  // PDF Manual box
  inner-box((margin + 2 * (5.4 + gap), ui-y), 5.4, 1.5, col-cli, "manual",
    [PDF Manual],
    [Auto-compiled definitions & examples])

  // ══════════════════════════════════════════
  // Layer 2: Core Library (middle)
  // ══════════════════════════════════════════
  let y2 = y1 - cli-h - 0.8
  let core-h = 5.2
  rounded-box((0, y2), total-w, core-h, col-core, "core-box")
  section-label((margin, y2 - 0.4), col-core, [Core Library (`problemreductions`)])

  // Row 1: Problem Types, Reduction Rules, Graph Engine
  let r1-y = y2 - 1.0
  inner-box((margin, r1-y), col-w + 1.2, col-h, col-core, "problems",
    [Problem Types],
    [`Problem` trait · `evaluate()` · size measures])

  inner-box((margin + col-w + 1.2 + gap, r1-y), col-w + 1.2, col-h, col-core, "rules",
    [Reduction Rules],
    [`ReduceTo<T>` · forward + inverse maps])

  inner-box((margin + 2 * (col-w + 1.2 + gap), r1-y), col-w + 1.4, col-h, col-core, "graph",
    [Graph Engine],
    [Dijkstra path search · overhead composition])

  // Row 2: Solvers, Example DB
  let r2-y = r1-y - col-h - gap
  inner-box((margin, r2-y), 5.4, 1.6, col-core, "solvers",
    [Solvers],
    [Brute-force · ILP (HiGHS / CBC / SCIP)])

  inner-box((margin + 5.4 + gap, r2-y), 5.4, 1.6, col-core, "exdb",
    [Example Database],
    [Canonical instances · ground-truth fixtures])

  inner-box((margin + 2 * (5.4 + gap), r2-y), 5.4, 1.6, col-core, "registry",
    [Variant Registry],
    [Dynamic dispatch · complexity metadata])

  // ══════════════════════════════════════════
  // Layer 3: Compile-time Infrastructure (bottom)
  // ══════════════════════════════════════════
  let y3 = y2 - core-h - 0.8
  let macro-h = 2.6
  rounded-box((0, y3), total-w, macro-h, col-macro, "macro-box")
  section-label((margin, y3 - 0.4), col-macro, [Procedural Macros (`problemreductions-macros`)])

  let m-y = y3 - 1.0
  inner-box((margin, m-y), 5.4, 1.3, col-macro, "overhead-macro",
    [`\#[reduction(overhead)]`],
    [Symbolic `Expr` AST · variable name validation])

  inner-box((margin + 5.4 + gap, m-y), 5.4, 1.3, col-macro, "variants-macro",
    [`declare_variants!`],
    [Type registration · complexity strings])

  inner-box((margin + 2 * (5.4 + gap), m-y), 5.4, 1.3, col-macro, "validation",
    [Compile-time Checks],
    [Getter method matching · expression parsing])

  // ══════════════════════════════════════════
  // Arrows between layers
  // ══════════════════════════════════════════
  let arr = (end: "straight", scale: 0.38)
  let arr-s = (thickness: 1pt, paint: luma(100))

  // CLI/API → Core
  line("cli.south", "problems.north",
    stroke: arr-s, mark: arr, shorten: (start: 0.08, end: 0.08))
  line("api.south", "rules.north",
    stroke: arr-s, mark: arr, shorten: (start: 0.08, end: 0.08))
  line("manual.south", "exdb.north",
    stroke: arr-s, mark: arr, shorten: (start: 0.08, end: 0.08))

  // Macros → Core (upward, dashed = compile-time)
  line("overhead-macro.north", "rules.south",
    stroke: (thickness: 1pt, paint: col-macro, dash: "dashed"),
    mark: arr, shorten: (start: 0.08, end: 0.08))
  line("variants-macro.north", "registry.south",
    stroke: (thickness: 1pt, paint: col-macro, dash: "dashed"),
    mark: arr, shorten: (start: 0.08, end: 0.08))
})
