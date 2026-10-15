#set text(size: 10pt)
#let data = json("identity-supports.json")
#let pixels(rows) = grid(columns: (0.58mm,) * 64, rows: (0.58mm,) * 64,
  ..rows.map(row => row.map(value => rect(width: 0.58mm, height: 0.58mm,
    fill: if value == 1 { black } else { white }, stroke: none))).flatten())
#align(center)[
  #grid(columns: (38mm, 12mm, 38mm, 12mm, 38mm), row-gutter: 2mm, align: center + horizon,
    [$U_0 V$], [], [$W_0 Z$], [], [$I_64$],
    box(stroke: 0.4pt, inset: 0.5pt, pixels(data.a)), text(size: 18pt)[$⊙$],
    box(stroke: 0.4pt, inset: 0.5pt, pixels(data.b)), text(size: 18pt)[$=$], box(stroke: 0.4pt, inset: 0.5pt, pixels(data.m)),
    [$p=8$], [], [$q=8$], [], [$s^2=64$])
  #v(3mm)
  #grid(columns: (2mm, auto, 5mm, 2mm, auto), gutter: 2mm, align: horizon,
    rect(width: 2mm, height: 2mm, fill: black, stroke: none), [Nonzero entry], [],
    rect(width: 2mm, height: 2mm, stroke: 0.4pt), [Zero entry])
]
