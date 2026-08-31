#let strip(sequence) = sequence.slice(
  if sequence.first() == [ ] {1} else {0},
  if sequence.last() == [ ] {-1} else {none}
)
