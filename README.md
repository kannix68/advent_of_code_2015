# Advent of code 2015

Advent of code 2015 solutions.

By kannix68@github.

## Solutions

Advent of code 2015 is at <http://adventofcode.com/>.
Thanks Eric Wastl and company!

## Input data

Input data given for my AOC login is saved in a text file
`adventcode_in[DD].txt`.

## Solutions

Solutions are saved to `adventcode_[DD][a|b].[prog-lang-extension]`.
Most are straight-forward, plain, non-elegant, non-optimized, ad-hoc/brute
force solutions.

## Programming language specifica

### perl
Perl means a perl 5 standard distribution,
tested using perl v5.18.2 on Mac OS X.

Unit tests using standard library Test::More.

### ruby
Ruby means a ruby 2.2 standard distribution (MRI),
tested using ruby v2.2.2 in a rvm environment on Mac OS X.

Unit Tests using standard library test/unit.

A base helper class Aocbase can be required from local file
(`require aocbase.rb`).

### R (R-lang)
R means R-language, tested using R v3.2.0 (Revolution R Open),
with R-Studio as editor on Mac OS X.

Some hardcoded paths/filenames in input data file reading.

Assertions using builtin `stopifnot` function (currently no real unit test).

### JavaScript
JavaScript is node.js code, tested using node.js v4.2.3 on Mac OS X.

For JS, a filename to read/process is expected to be
the first script commandline arg.
There should be a test input file for a given day challenge tests/examples.

Assertions using standard library assert.
files / filesystem reading using standard library fs.

### Groovy
Groovy is used for solutions unsing the Java JVM ecosystem.

Groovy version:

    Groovy Version: 2.4.5 JVM: 1.8.0_45 Vendor: Oracle Corporation OS: Mac OS X
