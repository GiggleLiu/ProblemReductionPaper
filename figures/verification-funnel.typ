#import "lib.typ": *

#set page(..fig-page)
#set text(..fig-text)

// Same two-color scheme as pipeline figure
#let col-human = rgb("#f28e2b")
#let col-agent = accent
#let col-bg-agent = accent-light
#let col-bg-human = col-human.lighten(85%)

// Four-layer verification funnel: (name, description, is-human)
#let layers = (
  ("Issue check", "rejects invalid proposals", false),
  ("Unit & round-trip tests", "rejects implementation errors", false),
  ("Agentic feature tests", "rejects behavioral issues", false),
  ("Contributor verification", "rejects quality gaps", true),
)

#canvas(length: 0.55cm, {
  import draw: *

  let n = 4
  let layer-h = 1.2
  let gap = 0.25
  let max-w = 12.0
  let min-w = 5.0
  let cx = 0
  let cap-h = 1.1

  let funnel-top = cap-h + 0.5

  // --- Top cap: "Candidate contributions" ---
  let top-y = funnel-top + cap-h
  let top-w = max-w + 1.0

  merge-path(
    close: true, fill: fill-light,
    stroke: (thickness: 1pt, paint: border),
    {
      line(
        (cx - top-w / 2, top-y),
        (cx + top-w / 2, top-y),
        (cx + max-w / 2, funnel-top),
        (cx - max-w / 2, funnel-top),
      )
    },
  )
  content(
    (cx, (top-y + funnel-top) / 2 + 0.1),
    text(7.5pt, weight: "bold", fill: fg, [Candidate contributions]),
  )
  content(
    (cx, (top-y + funnel-top) / 2 - 0.35),
    text(6pt, fill: fg-light, style: "italic", [proposals, implementations, reviews]),
  )

  // --- Filter layers ---
  for i in range(n) {
    let t-top = i / n
    let t-bot = (i + 1) / n
    let w-top = max-w - (max-w - min-w) * t-top
    let w-bot = max-w - (max-w - min-w) * t-bot
    let y-top = funnel-top - i * (layer-h + gap)
    let y-bot = y-top - layer-h
    let y-mid = (y-top + y-bot) / 2
    let t-mid = (i + 0.5) / n
    let w-mid = max-w - (max-w - min-w) * t-mid

    let (name, desc, is-human) = layers.at(i)
    let bg = if is-human { col-bg-human } else { col-bg-agent }
    let stroke-col = if is-human { col-human } else { col-agent }
    let text-col = stroke-col.darken(15%)

    // Trapezoid
    merge-path(
      close: true, fill: bg,
      stroke: (thickness: 1pt, paint: stroke-col),
      {
        line(
          (cx - w-top / 2, y-top),
          (cx + w-top / 2, y-top),
          (cx + w-bot / 2, y-bot),
          (cx - w-bot / 2, y-bot),
        )
      },
    )

    // Layer name + description
    content(
      (cx, y-mid + 0.15),
      text(7.5pt, weight: "bold", fill: text-col, name),
    )
    content(
      (cx, y-mid - 0.3),
      text(6pt, fill: stroke-col, style: "italic", desc),
    )

    // Right-side: subtle rejection indicator
    let edge-x = cx + w-mid / 2
    line(
      (edge-x + 0.05, y-mid), (edge-x + 1.2, y-mid),
      stroke: (thickness: 0.5pt, paint: stroke-col.lighten(50%), dash: "dotted"),
    )
    content(
      (edge-x + 1.35, y-mid), anchor: "west",
      text(5.5pt, fill: stroke-col.lighten(30%), [rejected]),
    )
  }

  // --- Bottom cap: "Verified code" ---
  let last-y-bot = funnel-top - (n - 1) * (layer-h + gap) - layer-h
  let bot-y = last-y-bot - 0.3
  let bot-cap-y = bot-y - cap-h
  let bot-w = min-w

  merge-path(
    close: true, fill: fill-light,
    stroke: (thickness: 1pt, paint: border),
    {
      line(
        (cx - bot-w / 2, bot-y),
        (cx + bot-w / 2, bot-y),
        (cx + bot-w / 2 - 0.8, bot-cap-y),
        (cx - bot-w / 2 + 0.8, bot-cap-y),
      )
    },
  )
  content(
    (cx, (bot-y + bot-cap-y) / 2 + 0.1),
    text(7.5pt, weight: "bold", fill: fg, [Verified code]),
  )
  content(
    (cx, (bot-y + bot-cap-y) / 2 - 0.35),
    text(6pt, fill: fg-light, style: "italic", [merged to main]),
  )

  // --- Left side: "Contributor ground truth" vertical arrow ---
  let gt-x = cx - max-w / 2 - 1.8
  let gt-top = funnel-top + cap-h * 0.5
  let gt-bot = bot-cap-y + 0.3

  line(
    (gt-x, gt-top), (gt-x, gt-bot),
    stroke: (thickness: 1.2pt, paint: col-agent),
    mark: (end: "straight", scale: 0.45),
  )
  content(
    (gt-x - 0.2, (gt-top + gt-bot) / 2),
    anchor: "east", angle: 90deg,
    text(6.5pt, weight: "bold", fill: col-agent.darken(10%),
      [Contributor ground truth]),
  )

  // Dashed arrows from ground truth into each layer
  for i in range(n) {
    let t-mid = (i + 0.5) / n
    let w-mid = max-w - (max-w - min-w) * t-mid
    let y-top = funnel-top - i * (layer-h + gap)
    let y-bot = y-top - layer-h
    let y-mid = (y-top + y-bot) / 2
    let target-x = cx - w-mid / 2

    let (_, _, is-human) = layers.at(i)
    let dash-col = if is-human { col-human.lighten(40%) } else { col-agent.lighten(40%) }

    line(
      (gt-x + 0.1, y-mid), (target-x - 0.1, y-mid),
      stroke: (thickness: 0.6pt, paint: dash-col, dash: "dashed"),
      mark: (end: "straight", scale: 0.3),
    )
  }

  // Connect ground truth to bottom cap
  line(
    (gt-x + 0.1, (bot-y + bot-cap-y) / 2),
    (cx - bot-w / 2 + 0.3, (bot-y + bot-cap-y) / 2),
    stroke: (thickness: 0.6pt, paint: col-agent.lighten(40%), dash: "dashed"),
    mark: (end: "straight", scale: 0.3),
  )

  // --- Legend at bottom (matching pipeline style) ---
  let ly = bot-cap-y - 0.7
  let lx = cx - 3.0
  line((lx, ly), (lx + 0.5, ly), stroke: 1pt + col-agent)
  content((lx + 0.65, ly), anchor: "west", text(6pt, [Agent verification]))
  line((lx + 3.5, ly), (lx + 4.0, ly), stroke: 1pt + col-human)
  content((lx + 4.15, ly), anchor: "west", text(6pt, [Human verification]))
})
