#import "lib.typ": *

#set page(..fig-page)
#set text(..fig-text)

#import "@preview/cetz:0.4.2": canvas, draw

#canvas(length: 0.58cm, {
  import draw: *

  let card-w = 3.0
  let card-h = 0.76
  let col-gap = 0.36
  let row-h = 0.92
  let band-h = 0.10
  let human-fill = white
  let human-stroke = luma(150)
  let agent-fill = fill-accent

  let tasks = (
    ("Harness\nengineering", 1.0),
    ("Strategic\nplanning", 1.0),
    ("Merge\nauthorization", 1.0),
    ("Canonical\nexamples", 0.85),
    ("Mathematical\nverification", 0.8),
    ("Code\nreview", 0.15),
    ("Implementation", 0.05),
    ("Convention\nenforcement", 0.0),
  )

  let x-left = 0
  let x-right = card-w + col-gap

  let task-pos(i) = {
    if i < 4 {
      (x-left, -i * row-h)
    } else {
      (x-right, -(i - 4) * row-h)
    }
  }

  let card(x, y, label, frac, id) = {
    rect(
      (x - card-w / 2, y - card-h / 2),
      (x + card-w / 2, y + card-h / 2),
      radius: 3pt,
      fill: fill-light,
      stroke: (paint: border, thickness: 0.8pt),
      name: id,
    )
    content((x, y + 0.08), align(center, text(4.9pt, fill: fg)[#label]))

    let bx0 = x - card-w / 2
    let bx1 = x + card-w / 2
    let by0 = y - card-h / 2
    let by1 = by0 + band-h
    rect(
      (bx0, by0),
      (bx1, by1),
      fill: none,
      stroke: (paint: luma(205), thickness: 0.25pt),
    )
    if frac > 0.01 {
      rect(
        (bx0, by0),
        (bx0 + card-w * frac, by1),
        fill: human-fill,
        stroke: (paint: human-stroke, thickness: 0.25pt),
      )
    }
    if frac < 0.99 {
      rect(
        (bx0 + card-w * frac, by0),
        (bx1, by1),
        fill: agent-fill,
        stroke: (paint: accent, thickness: 0.25pt),
      )
    }
  }

  let arrow(x0, y0, x1, y1) = {
    line(
      (x0, y0 - card-h / 2 - 0.03),
      (x1, y1 + card-h / 2 + 0.03),
      stroke: (paint: accent, thickness: 0.8pt),
      mark: (end: "straight", scale: 0.28),
    )
  }

  content((x-left - card-w / 2, 0.62), text(5.8pt, fill: fg, weight: "bold")[Human-led], anchor: "west")
  content((x-right + card-w / 2, -3 * row-h - 0.62), text(5.8pt, fill: accent, weight: "bold")[Agent-led], anchor: "east")

  for (i, (label, frac)) in tasks.enumerate() {
    let (x, y) = task-pos(i)
    card(x, y, label, frac, "task-" + str(i))
  }

  for i in range(0, 3) {
    let (x0, y0) = task-pos(i)
    let (x1, y1) = task-pos(i + 1)
    arrow(x0, y0, x1, y1)
  }

  line(
    (x-left + card-w / 2 + 0.08, -3 * row-h),
    (x-right - card-w / 2 - 0.08, 0),
    stroke: (paint: accent, thickness: 0.8pt),
    mark: (end: "straight", scale: 0.28),
  )

  for i in range(4, 7) {
    let (x0, y0) = task-pos(i)
    let (x1, y1) = task-pos(i + 1)
    arrow(x0, y0, x1, y1)
  }

  let ly = -3 * row-h - 0.82
  rect(
    (x-left - card-w / 2, ly - 0.07),
    (x-left - card-w / 2 + 0.20, ly + 0.07),
    fill: human-fill,
    stroke: (paint: human-stroke, thickness: 0.35pt),
  )
  content((x-left - card-w / 2 + 0.27, ly), text(5.2pt, fill: fg)[Human], anchor: "west")
  rect(
    (x-left + 1.15, ly - 0.07),
    (x-left + 1.35, ly + 0.07),
    fill: agent-fill,
    stroke: (paint: accent, thickness: 0.35pt),
  )
  content((x-left + 1.42, ly), text(5.2pt, fill: fg)[Agent], anchor: "west")
})
