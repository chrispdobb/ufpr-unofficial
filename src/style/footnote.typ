#import "../common/note.typ": note

#let footnote-style(body) = {
  set footnote.entry(
    gap: 1.5em,
    indent: 0cm
  )
  show footnote.entry: it => {
    show: note
    set cite(form: "full")
    link(
      it.note.location(),
      super(counter(footnote).display(at: it.note.location(), it.note.numbering))
    )
    it.note.body
  }
  body
}
