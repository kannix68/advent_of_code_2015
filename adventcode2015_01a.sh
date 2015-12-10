#!/bin/bash
##
# advent of code 2015. kannix68 (@github).
# Day 1: Not Quite Lisp.
#
# uses bash shell.
# Assumes a unix-like execution environment,
#   having/requiring the following unix toolbox tools:
#   echo, cat, grep, wc, tr, expr.

INFILE="adventcode2015_in01.txt"
echo "using input file $INFILE"
ups=`cat $INFILE |grep --only-matching "(" |wc -l |tr -d " "`
echo "ups=$ups"
downs=`cat $INFILE |grep --only-matching ")" |wc -l |tr -d " "`
echo "downs=$downs"
sum=`expr $ups - $downs`
echo "final floor # = $sum"
