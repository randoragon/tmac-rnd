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
    - RT
    - SH, NH
3. Added the following macros:
    - SHs, NHs, Hs
4. Added the following number registers:
    - SH1..SH5, NH1..NH2

### New Headings

The new heading syntax is as follows:

    .SH <level> [adjust]
    .NH <level> [adjust]

The second argument (adjust) is transparently passed to `.ad`.

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

### Miscellaneous Changes

`RT` now invokes `.ad b` every time. This was a necessary addition
to allow `.NH` and `.SH` to accept adjust arguments.

## Dependencies

`rnd` relies on the following packages provided by Neatroff:

- `mpost`: URLs
- `msdisp`: display macros
- `mskeep`: keep blocks (needed by display macros)

## Installation

To keep maintenance and writing new extensions easy and sane, the
package is split across multiple files, as seen in the `src`
directory. However, multiple macro files are too inconvenient to
carry around, so the Makefile within this repository can stitch
all files scattered in `src` into a **single, complete form**.

To build the file containing all macros, run:

    make

This will create a new `rnd.tmac` file in the base directory.
