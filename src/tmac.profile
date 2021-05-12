. \" Different document profiles for rnd macros
. \" vim: ft=groff
.
.   \" NOTE - the default profile
.   \" for note-taking, similar use-cases to markdown
.de note
.nr DT 1
. \" Disable page numbering, header/footer
.rm LH CH RH LF CF RF
.rm note report book
..
.
.   \" REPORT - for condensed technical reports
.de report
.nr DT 2
.rm note report book
..
.
.   \" BOOK - for simple books
.de book
.nr DT 3
.rm note report book
..
