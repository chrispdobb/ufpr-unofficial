#let figure-outline-page = context {
  let cells = ()
  for f in query(figure.where(outlined: true)) {
    cells.push(link(f.location())[
      #upper(f.caption.supplement)
      #f.caption.counter.at(f.location()).first()
      #f.caption.separator
    ])
    cells.push(link(f.location())[
      #f.caption.body
      #box(width: 1fr, repeat[.])
      #counter(page).at(f.location()).first()
    ])
  }
  if cells != () [
    = Lista de Ilustrações
    #grid(..cells, columns: (auto, 1fr), align: (right, left))
    #pagebreak(weak: true)
  ]
}
