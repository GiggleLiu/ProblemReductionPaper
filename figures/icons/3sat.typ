#import "../lib.typ": *
#set page(width: auto, height: auto, margin: 0pt)
#set text(size: 7.5pt, font: "Helvetica")

#box(
  width: 1.2cm, height: 1.2cm,
  stroke: (thickness: 0.4pt, paint: luma(180), dash: "dashed"),
  radius: 3pt,
  inset: 2pt,
  align(center + horizon, text(5pt, fill: luma(150), [3SAT])),
)