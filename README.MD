# troff rnd macros

## Table of Contents

1. [Description](https://github.com/Randoragon/tmac-rnd#description)
2. [Features](https://github.com/Randoragon/tmac-rnd#features)
    - [Differences with vanilla ms](https://github.com/Randoragon/tmac-rnd#differences-with-vanilla-ms)
    - [New Headings](https://github.com/Randoragon/tmac-rnd#new-headings)
    - [Lists](https://github.com/Randoragon/tmac-rnd#lists)
    - [Media Macros](https://github.com/Randoragon/tmac-rnd#media-macros)
    - [Table of Contents](https://github.com/Randoragon/tmac-rnd#table-of-contents-1)
    - [Document Profiles](https://github.com/Randoragon/tmac-rnd#document-profiles)
3. [Dependencies](https://github.com/Randoragon/tmac-rnd#dependencies)
3. [Dependencies](https://github.com/Randoragon/tmac-rnd#dependencies)
4. [Installation](https://github.com/Randoragon/tmac-rnd#installation)

## Description

`rnd` is a general-purpose macro package for troff that is based on
the old `ms` macros originally used by Bell Labs, with numerous
extensions, additions and modifications.

The package aims to provide a flexible interface with many settings
that globally affect the document (inspired by the `mm` macros), but
unlike `mm` it enables the user to override most defaults on an
individual basis.

The `rnd` macros serve as my primary tool for writing documents in
troff, and as such I reserve the right to change them in any way I
want to fit into my personal workflow. At no point should this
macro package be considered "complete", for the same reasons.

The macro package is written with Ali Gholami Rudi's Neatroff
implementation of roff in mind and it relies on many extended
contructs that Neatroff introduces. To learn more about Neatroff you
can start [here](https://litcave.rudi.ir/neatroff.pdf).

## Features

### Differences with vanilla ms

1. Removed the following macros:
    - TM, IM, MF, MR, LT, RP, TR
    - UX, US
    - MH, PY, AW
    - S1, S2, S3, SY, CS
2. Removed the following registers:
    - IM, MN, CS, ST
3. Modified the following macros:
    - TL, AU, AI (visual tweaks)
    - SH, NH
4. Added the following macros:
    - **headings:** SHs, NHs, Hs, SHo, NHo, Ho, NHf, HE, H{
    - **lists:** BL, AL, LI, LE
    - **media:** PDF, URL
    - **toc:** toc.init, toc.chapter, toc.section, TOC, CP
    - **profile:** note, report, book, fmt
5. Reserved the following number registers:
    - **headings:** SH, SH1..SH5, NH1..NH5, HE, \_s, \_a
    - **lists:** LV, Lv, LT1..LT9, LD0..LD9, LO1..LO9, LS1..LS9, Ls1..Ls9, LC1..LC9, Li
    - **toc:** TM
    - **profile:** DT
    - **misc:** \_d, \_o, \_maxw, \_w, \_h, \_i, \_u, NT
6. Reserved the following string names:
    - **headings:** SH1..SH5, NH1..NH5, \_a, \_f
    - **media:** def\_col\_url, col\_url, \_col
    - **toc:** \_s, HP
7. Reserved the following environment names:
    - \_toc

### New Headings

The new heading syntax comes in 2 forms which look as follows:

    .SH [options] <level> text...
    .NH [options] <level> text...

**or**

    .SH [options] <level>
    text...
    .HE <toc name>
    .NH [options] <level>
    text...
    .HE <toc name>

The second form exists in case you want to have a URL in your
heading, or any other advanced formatting that can't be done
in-line. There is one caveat: the second form does not support
the *u* option (options are explained below).

*toc name* is the name displayed in a table of contents. Only
headings of the second form require it to be specified separately
in the `HE` macro, because for headings of the first form, the
text is taken directly from the `NH` or `SH` macro.

#### Options

*options* is a single word composed of lowercase letters of the
following form:

    [l|c|r][b][i][u]

- *l*, *c*, *r* denote adjustment to the left, center or right
- *b* denotes **emboldening**
- *i* denotes *italics*
- *u* denotes <u>underline</u>

Options can be skipped, in which case the default settings will
be used. The default option strings for each level of section
and numbered headings are stored in `SH1..SH5` and `NH1..NH5`
strings. You can change these defaults easily with `SHo`, `NHo`
and `Ho` macros:

    .SHo cb b bi i i
    .NHo cb b bi i i
    .Ho  cb b bi i i

The above macros change level one headings to be centered and
bold, level 2 headings to be bold, level 3 to be bold and italic,
and level 4 and 5 headings to be italic. You can override these
defaults in each individual heading invocation, though.

#### Point size

Headings have configurable point sizes per level. The point size
of each level is stored in `SH1..SH5` for section headings and
in `NH1..NH5` for numbered headings. You can easily set these
registers to desired values using the new `SHs`, `NHs` and `Hs`
macros:

    .SHs 16 15 14 13 12
    .NHs 16 15 14 13 12
    .Hs  16 15 14 13 12

`Hs` sets the same point sizes for both `SH` and `NH`, it's just
a shorthand for calling `SHs` and `NHs` with the same arguments.
You can omit up to 4 arguments to initialize the remaining values
to the last one. The following 2 lines do the same thing:

    .NHs 14 13 12 12 12
    .NHs 14 13 12

This functionality is inspired by the `mm` macros.

For numbered headings, you can also set number formats for each
level separately with the `NHf` macro, e.g.:

    .NHf A a i 1 1

Empty or missing arguments will be silently ignored. By default,
all formats are set to arabic (1).

#### Named references

For all headings, a Neatroff **named reference** is automatically
created, for the purpose of generating tables of contents.

For numbered headings, the reference name matches the current
chapter prefix (*toc prefix*) followed by the heading "prefix".
For example, if you start a new chapter with prefix "1", a
numbered heading "1. Example" will have the reference
`#h11.`, while a heading with prefix "A.3.ii. Nested Example"
within a chapter prefixed "B" will have the reference `#hBA.3.ii.`
(**note the trailing periods!**). If a heading appears outside
of a chapter, the *toc prefix* part is an empty string (i.e.
it should be skipped).

Section headings don't have prefixes, so they are enumerated
normally, i.e. `#h1`, `#h2` and so on (**no trailing period!**).
The rules for chapter prefixes are the same as with numbered
headings.

### Lists

Lists are much inspired by the `mm` macros. You can start a
new list with the following macros, for bulleted and enumerated
lists respectively:

    .BL [symbol] [indent] [offset] [spacing]
    .AL [format] [indent] [offset] [spacing]

- *symbol* is `\(bu` by default, but any non-empty string is valid
- *format* is transparently passed to `.af` for different number
formatting
- *indent* is additional indentation, set to `4n` by default
- *offset* is indentation added to all prior indentation to separate
the symbol/number from the item body. Set to `4n` by default
- *spacing* is vertical distance added inbetween all list items.
By default it's equal to `0`, which results in simple line breaks.

After initializing a list, each list item can be added with

    .LI [symbol] [indent] [offset]

Followed by the body of the item.
The arguments for `LI` are identical to those of `BL` (except
*spacing*), and they serve as an optional override that affects
only a particular item.

At the end, the list must be terminated with

    .LE

Lists can be nested up to 9 levels.

### Media Macros

PDF images can be embedded with

    .PDF <adjust> <path> <width> <height> [scale]

- *adjust* - `l`, `c`, `r` or a number denoting indentation
- *path* - path to the image file
- *width* - width of the image
- *height* - height of the image
- *scale* - scaling factor in 1/1000, 1000 is the maximum available width

The scaling mechanism works in the following way:  
If *scale* is not supplied, the image will aim to be originally-sized, but
capped at maximum on-page width (the maximum width is computed as
`\n(.l-\n(.i`). If *scale* is supplied, 1000 denotes the maximum width.

Hyperlinks can be embedded with

    .URL <destination> [text] [text2]

Where *destination* is the URI, *text* is displayed as a clickable, followed
by non-clickable *text2* (similar to how additional parameters are handled
in `.B` and `.I` macros).
If *text* is an empty string (or omitted), *destination* is used instead.  
By default, all URLs have a custom color stored in the `def_col_url`
string. If you want a different color, you should temporarily define the
`col_url` string. `def_col_url` should be treated as a read-only resource.

### Table of Contents

All headings can be automatically included into the ToC.
You can control which headings get added by changing the value
of the `TM` register which denotes the largest heading number
to be included, and is equal to 2 by default (which means
headings of level 1 and 2 will be included).

Other than headings, you can define new chapters with `CP`:

    .CP <on-page name> <toc prefix> [toc name]

Each chapter will break to a new page, disable the top header
of that page and replace it with a nice caption.

- *on-page name* is the text that will be printed on the page
- *toc prefix* is typically a short string that will appear
in ToC to the left of the chapter name, typically it's the
chapter number, or something like "A", "B", "C" for appendices
- *toc name* is an optional alternate title for the ToC

Sometimes you might want to display full text "Chapter 1 - Title"
on the page, but in the ToC you want a format like "1. Title".
The *toc name* argument lets you override *on-page name* for
those purposes. If you don't specify *toc name*, *on-page name*
will be used by default.

Chapters automatically create named references of the form
`#c1`, `#c2`, `#c3` and so on. These references are used when
generating the table of contents.

The ToC can be printed anywhere within the document, any number
of times, without the need to wait for headings/chapters to accumulate.
To print the ToC, you must supply the **exact line**:

    .TOC

This convenient functionality is made possible by utilizing the
`stderr` stream as intermediary output instead of relying on diversions.
However, this comes at a cost:

- An external script must be used to capture and parse `stderr`, then
merge it into the original document and recompile.
- Please take a look at the `ntmake` script within this repository
to see how you can build the document with ToC.
- **If you don't plan on using .TOC, you can compile as normal,
without any complications!**

### Document Profiles

In order to provide minimal support for different document
types, there are a couple of macros that control the global
configuration. All of these should be invoked as one of the
first macros (if not first).

    .note
    .report
    .book

1. `note` is the default profile which aims to provide
sane defaults for writing quick notes, akin to markdown.
2. `report` is for writing technical reports.
3. `book` is for writing simple books.

#### Brief profiles comparison

Feature | `note` | `report` | `book`
---: | :---: | :---: | :---:
page numbering | | ✗ | ✗
separate cover page | | ✗ | ✗
`.TOC` causes page break | | ✗ | ✗
`.CP` causes page break | | ✗ | ✗

The `book` and `report` produce slightly different output
visually in some aspects. For example, a new chapter in a
report starts from the top of the page, whereas in a book
there is additional spacing from the top of the page and
the chapter name point size is slightly bigger, etc.

## Dependencies

`rnd` relies on the following packages provided by Neatroff:

- `mpost`: URLs
- `msdisp`: display macros
- `mskeep`: keep blocks (needed by display macros)

The `tmac.main` file automatically sources these macro packages, and
there should be no issues (unless you modified them by hand) since
Neatroff ships with them by default.

## Installation

To keep maintenance and writing new extensions easy and sane, the
package is split across multiple files, as seen in the `src`
directory. However, multiple macro files are too inconvenient to
carry around, so the Makefile within this repository can stitch
all files scattered in `src` into a **single, complete form**.

To build the file containing all macros, run:

    make

This will create a new `tmac.rnd` file in the base directory.
