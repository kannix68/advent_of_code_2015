#!/usr/bin/perl
##
# advent of code 2015. kannix68.
# Day 10: Day 10: Elves Look, Elves Say.
# Part [B]
#
require 5;
use strict;
use warnings;

#** Helpers

my $DEBLOG = 0;  # 0|1

sub deblog($) {
  if ($DEBLOG) {
    my $s = shift();
    chomp($s);
    print STDERR "D: $s\n";
  }
}

sub infolog($) {
  my $s = shift();
  chomp($s);
  print STDERR "I: $s\n";
}

sub getdatafile() {
  deblog("basename=$0\n");
  my $infile = $0;
  $infile =~ s/^(?:\.\/)?(adventcode2015_)(.*?)[a-z]?\.pl$/$1in$2\.txt/;
  if ($infile eq $0) {
    die("problem finding datafile (regex).");
  }
  deblog("data filename=$infile\n");
  return($infile);
}

sub readdata() {
  my $infile = getdatafile();
  
  # one line input
  open(DATAFP, $infile)
    or die($!);
  my $data = <DATAFP>;
  close(DATAFP);
  $data =~ s/(\x0D)?\x0A$//; # get rid of lineending
  main::deblog("data is len=" . length($data) . ", >$data<.");
  return($data);
}

#** our algorithm
sub algo_exec($) {
  my $ins = shift();
  deblog("input = >$ins<.");
  my $outs = '';
  my $lastc = '';
  my $cct = 0;
  my $c = '';
  for (my $i=0; $i < length($ins); $i++) {
    $c = substr($ins, $i, 1);
    if ($c eq $lastc) {
      $cct++;
    } else {
      if ($lastc ne '') { # < omit inital char-change at pos 0
        $outs .= $cct . $lastc;
      }
      $cct = 1;
      $lastc = $c;
    }
  }
  $outs .= $cct . $c;  #< final chars
  deblog("returns >$outs< from >$ins<");
  return($outs);
}

#** "MAIN", including unit tests

use Time::HiRes qw(time);

my $iterations = 50;
my $inq = readdata(); # "3113322113"; # "1";

infolog("input data = >$inq<");

my $t = time();
my $k;
for ($k = 1; $k <= $iterations; $k++ ) {
  infolog("in #$k (##". length($inq) . ") = >" . substr($inq, 0, 79) . " ...<.");
  $inq = algo_exec($inq);
}
$k--;
infolog("result #$k (##" . length($inq) . ") = >" . substr($inq, 0, 79) . " ...<.");

$t = time() - $t;
infolog("program ends after $t secs.");

__END__

look-and-say:
1 becomes 11 (1 copy of digit 1).
11 becomes 21 (2 copies of digit 1).
21 becomes 1211 (one 2 followed by one 1).
1211 becomes 111221 (one 1, one 2, and two 1s).
111221 becomes 312211 (three 1s, two 2s, and one 1).
