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

## Installation

To keep maintenance and writing new extensions easy and sane, the
package is split across multiple files, as seen in the `src`
directory. However, multiple macro files are too inconvenient to
carry around, so the Makefile within this repository can stitch
all files scattered in `src` into a **single, complete form**.

To build the file containing all macros, run:

    make

This will create a new `rnd.tmac` file in the base directory.
