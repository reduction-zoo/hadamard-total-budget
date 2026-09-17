#set text(size: 9.5pt)
#let cell(a, c) = {
  let missing = (a == 0 and calc.rem(c, 2) == 1) or (a == 1 and calc.rem(c, 2) == 0)
  let body = if a == 0 { if missing { $X_#calc.floor(c / 2)$ } else { $L_#calc.floor(c / 2)$ } }
    else if a == 1 { if missing { $Y_#calc.floor(c / 2)$ } else { $R_#calc.floor(c / 2)$ } }
    else { [#sym.circle.filled] }
  box(width: 6.6mm, height: 6.6mm,
    fill: if missing { white } else { luma(90%) },
    stroke: if missing { (paint: black, thickness: 0.65pt, dash: "dashed") } else { 0.3pt },
    align(center + horizon, body))
}
#align(center)[
  #grid(columns: (62mm, 82mm), gutter: 10mm, align: center + horizon,
    [*Anchor grid: $K=4$, $s=8$* #v(3mm)
      #grid(columns: (8mm,) + (6.6mm,) * 8, rows: (6.6mm,) * 9, align: center + horizon,
        [], ..range(8).map(c => [#c]),
        ..range(8).map(a => ([#a],) + range(8).map(c => cell(a,c))).flatten())],
    [*Why the frame has one orientation* #v(4mm)
      #align(left)[
        A complete anchor row: $8$ vectors. \
        An anchor column: $7$ vectors. \
        Their intersection: $1$ vector.
        #v(3mm)
        $8+7-1=14>8$.
        #v(3mm)
        They cannot share the same factor line. \
        Every row–column intersection propagates \
        the opposite orientations.
        #v(4mm)
        A top anchor row also suffices: \
        $4+7-1=10>8$.
      ]],
  )
  #v(3mm)
  Solid cells are anchors; dashed cells retain the two selector orientations.
]
