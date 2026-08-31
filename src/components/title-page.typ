#import "../common/note.typ": note

#let title-page(
  title-display: [],
  author-display: [],
  author-count: 0,
  city-year: [],
  description: []
) = page[
  #set align(center)
  #author-display
  #for _ in range(0, 13 - author-count) {linebreak()}
  #title-display
  \ \ \
  #align(right, block(width: 50%)[
    #set align(left)
    #set par(first-line-indent: 0cm)
    #show: note
    #description
  ])
  #city-year
]
