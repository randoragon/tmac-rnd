# troff rnd macros

## Description

`rnd` is a general-purpose macro package for troff that is based on
the old `ms` macros originally used by Bell Labs, with numerous
extensions and/or slight modifications.

The `rnd` macros serve as my primary tool for writing documents in
troff, and as such I reserve the right to change them in any way I
want to fit into my personal workflow. At no point should this
macro package be considered "complete", for the same reasons.

The macro package is written with Ali Gholami Rudi's Neatroff
implementation of roff in mind. To learn more about Neatroff you
can start [here](https://litcave.rudi.ir/neatroff.pdf). The majority
of features shouldn't rely on Neatroff's extended language, but
I don't care to check compatibility with other implementations of
the roff language, so nothing is guaranteed.

## Vanilla ms Modifications

1. Removed the following macros:
    - TM, IM, MF, MR, LT, RP, TR
    - UX, US
    - MH, PY, AW
2. Modified the following macros:
    - SH, NH
3. Added the following macros:
    - **headings:** SHs, NHs, Hs, Hf, H{
    - **lists:** BL, AL, LI, LE
    - **media:** PDF, URL
4. Reserved the following number registers:
    - **headings:** SH, SH1..SH5, NH1..NH2
    - **lists:** LV, Lv, LT1..LT9, LD0..LD9, LO1..LO9, LS1..LS9, Ls1..Ls9, LC1..LC9, Li
    - **misc:** \_d, \_o, \_maxw, \_w, \_h, \_i, \_u
5. Reserved the following string names:
    - **headings:** \_a, \_f
    - **media:** def\_col\_url, col\_url, \_col

### New Headings

The new heading syntax is as follows:

    .SH [flags] <level> text...
    .NH [flags] <level> text...

#### Flags

*flags* are a single word composed of lowercase letters of the
following form:

    [l|c|r][b][i][u]

- *l*, *c*, *r* denote adjustment to the left, center or right
- *b* denotes **emboldening**
- *i* denotes *italics*
- *u* denotes <u>underline</u>

Flags can be skipped, in which case the current settings will
be used.

#### Point size

Headings have configurable point sizes per level. The point size
of each level is stored in `SH1..SH5` for section headings and
in `NH1..NH2` for numbered headings. You can easily set these
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
level separately with the `Hf` macro, e.g.:

    .Hf A a i 1 1

Empty or missing arguments will be silently ignored. By default,
all formats are set to arabic (1).

#### Named references

For all headings, a Neatroff **named reference** is automatically
created.

For numbered headings, the reference name matches the "prefix".
For example, a numbered heading "1. Example" will have the reference
`#h1.`, while a heading with prefix "A.3.ii. Nested Example" will
have the reference `#hA.3.ii.` (**note the trailing periods!**).

Section headings don't have prefixes, so they are enumerated
normally, i.e. `#h1`, `#h2` and so on (**no trailing period!**).

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

    .URL <destination> [text]

Where *destination* is the URI, and *text* is displayed as a clickable.
If *text* is omitted, *destination* is used instead.  
By default, all URLs have a custom color stored in the `def_col_url`
string. If you want a different color, you should temporarily define the
`col_url` string. `def_col_url` should be treated as a read-only resource.

## Dependencies

`rnd` relies on the following packages provided by Neatroff:

- `mpost`: URLs
- `msdisp`: display macros
- `mskeep`: keep blocks (needed by display macros)

The `rnd` macro file does not source any external files;
it is up to you to include the dependencies with `-m`
when calling Neatroff.

## Installation

To keep maintenance and writing new extensions easy and sane, the
package is split across multiple files, as seen in the `src`
directory. However, multiple macro files are too inconvenient to
carry around, so the Makefile within this repository can stitch
all files scattered in `src` into a **single, complete form**.

To build the file containing all macros, run:

    make

This will create a new `tmac.rnd` file in the base directory.
