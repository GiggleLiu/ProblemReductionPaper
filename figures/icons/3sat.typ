#import "../lib.typ": *
#set page(width: auto, height: auto, margin: 1pt)
#set text(size: 7.5pt, font: "Helvetica")

#canvas({
  import draw: *
  circle((0, 0), radius: 1.4cm)
  content((0, 0), text(7.5pt, weight: "bold", fill: red, [3SAT]))
})