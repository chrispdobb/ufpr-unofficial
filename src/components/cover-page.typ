#let cover-page(title-display: [], author-display: [], city-year: []) = page(
  background: image("../resources/cover.png")
)[
  #set align(center)
  UNIVERSIDADE FEDERAL DO PARANÁ
  \ \ \
  #author-display
  #place(horizon+center, title-display)
  #city-year
]
