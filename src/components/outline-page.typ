#let outline-page = context {
  let cells = ()
  let fmt = (weight: "regular", case: it => it)
  for h in query(heading.where(outlined: true)) {
    fmt.weight = if h.level == 1 {"bold"} else {"regular"}
    fmt.case = if h.level <= 2 {upper} else {it => it}

    if h.numbering == none {cells.push[]}
    else {
      cells.push(link(
        h.location(),
        text(
          weight: fmt.weight,
          numbering(h.numbering, ..counter(heading).at(h.location()))
        )
      ))
    }

    cells.push(link(
      h.location(),
      text(
        weight: fmt.weight,
        (fmt.case)[
          #h.body
          #box(width: 1fr, repeat[.])
          #counter(page).at(h.location()).first()
        ]
      )
    ))
  }
  [= Sumário]
  grid(..cells, columns: (auto, 1fr))
  pagebreak(weak: true)
}
