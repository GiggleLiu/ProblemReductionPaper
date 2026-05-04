#import "lib.typ": *

#set page(..fig-page)
#set text(..fig-text)

#canvas(length: 0.45cm, {
  import draw: *

  let mark-end = (end: "straight", scale: 0.45)
  let flow = stroke-edge
  let soft = (paint: luma(100), thickness: 0.75pt)

  // Box helper matching Figure 5: small radius, thin strokes, Helvetica.
  let node(cx, cy, w, h, title, subtitle: none, accent-node: false, name-id: none) = {
    let fill = if accent-node { fill-accent } else { white }
    let stroke = if accent-node {
      (paint: accent, thickness: 0.9pt)
    } else {
      (paint: border, thickness: 0.65pt)
    }
    rect((cx - w / 2, cy - h / 2), (cx + w / 2, cy + h / 2),
      radius: 3pt, fill: fill, stroke: stroke, name: name-id)
    content((cx, cy),
      anchor: "center",
      align(center, {
        text(6.1pt, weight: "bold", fill: fg, title)
        if subtitle != none {
          linebreak()
          text(5.0pt, fill: if accent-node { accent.darken(15%) } else { fg-light }, subtitle)
        }
      }))
  }

  // Small SKILL.md-style document corner reused from Figure 5, for generated files.
  let file-node(cx, cy, w, h, title, subtitle: none, name-id: none) = {
    node(cx, cy, w, h, title, subtitle: subtitle, name-id: name-id)
    let fold = 0.28
    line(
      (cx + w / 2 - fold, cy + h / 2),
      (cx + w / 2 - fold, cy + h / 2 - fold),
      (cx + w / 2, cy + h / 2 - fold),
      close: true,
      fill: fill-light,
      stroke: (paint: border, thickness: 0.45pt),
    )
  }

  // Title cue, consistent with Figure 5 panel headings.
  content((0.0, 8.0), text(8pt, weight: "bold", fill: fg)[canonical example round trip], anchor: "west")

  // Main chain.
  node(3.2, 4.25, 5.1, 1.35,
    [GitHub issue],
    subtitle: [definition · example · solution],
    accent-node: true,
    name-id: "issue")

  node(11.0, 4.25, 5.7, 1.55,
    [example database],
    subtitle: [canonical builder],
    name-id: "builder")

  // Generated artifacts, neutral like automation skills in Figure 5.
  file-node(18.6, 6.2, 4.8, 1.25,
    [JSON fixtures],
    subtitle: [source · target · answer],
    name-id: "json")
  file-node(18.6, 4.25, 4.8, 1.25,
    [round-trip tests],
    subtitle: [reduce · solve · map back],
    name-id: "tests")
  file-node(18.6, 2.3, 4.8, 1.25,
    [PDF manual],
    subtitle: [diagram · proof sketch],
    name-id: "manual")
  file-node(24.95, 4.25, 4.9, 1.25,
    [`pred create`],
    subtitle: [`--example`],
    name-id: "cli")

  node(31.0, 4.25, 5.1, 1.35,
    [Stage 6 review],
    subtitle: [contributor checks outputs],
    accent-node: true,
    name-id: "review")

  // Flow arrows.
  line("issue.east", "builder.west", stroke: flow, mark: mark-end, name: "extract")
  content((7.1, 4.68), text(5.3pt, style: "italic", fill: fg-light)[extract])

  // Fan-out from canonical builder to all generated artifacts.
  let fork-x = 14.9
  line("builder.east", (fork-x, 4.25), stroke: flow)
  line((fork-x, 4.25), (fork-x, 6.2), "json.west", stroke: flow, mark: mark-end)
  line((fork-x, 4.25), "tests.west", stroke: flow, mark: mark-end)
  line((fork-x, 4.25), (fork-x, 2.3), "manual.west", stroke: flow, mark: mark-end)
  line("tests.east", "cli.west", stroke: soft, mark: mark-end)

  // Review receives all visible outputs; a bracket keeps the right side tidy.
  let merge-x = 27.85
  line("json.east", (merge-x, 6.2), (merge-x, 4.25), stroke: flow)
  line("manual.east", (merge-x, 2.3), (merge-x, 4.25), stroke: flow)
  line("cli.east", (merge-x, 4.25), stroke: flow)
  line((merge-x, 4.25), "review.west", stroke: flow, mark: mark-end)

  // Back edge: visual drift becomes human-visible, but keep it subtle.
  line("review.south", (31.0, 1.25), (3.2, 1.25), "issue.south",
    stroke: (paint: accent, thickness: 0.8pt, dash: "dashed"),
    mark: mark-end)
  content((17.0, 1.0),
    text(5.5pt, style: "italic", fill: accent.darken(15%))[visible drift returns to the source example])
})
