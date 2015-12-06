#!/bin/perl
##
# advent of code 2015. kannix68 (@github).
# Day 3: Perfectly Spherical Houses in a Vacuum.
# Part [B].

require 5;
use strict;
use English;

my $DEBLOG = 0;  # 0|1

#** Helpers

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
  my $data = shift();
  my $i;
  my @x_posa = (0, 0);
  my @y_posa = (0, 0);
  my %positions;
  
  # starting position is delivered/added:
  my $idx = 0;
  my $k;
  $k = $x_posa[$idx]. ',' . $y_posa[$idx];
  $positions{$k}++;
  deblog("#<initial>: idx=$idx; num keys=" . scalar(keys(%positions)) . "; key=$k; value=" . $positions{$k});
  for($i=0; $i < length($data); $i++) {
    $idx = $i % 2;
    my $c = substr($data, $i, 1);
    if ($c eq '>') {
      $x_posa[$idx]++;
    } elsif ($c eq '<') {
      $x_posa[$idx]--;
    } elsif ($c eq '^') {
      $y_posa[$idx]++;
    } elsif ($c eq 'v') {
      $y_posa[$idx]--;
    } else {
      print STDERR "$!, input error on >$c<.";
      die "input error";
    }
    my $k = $x_posa[$idx] . ',' . $y_posa[$idx];
    $positions{$k}++;
    my $v = $positions{$k};
    my $d = scalar keys %positions;
    if ( $i < 10 ) {
      deblog("# $i: idx=$idx; op=$c; num keys=$d; key=$k; value=$v");
    }
  }
  my $d = scalar keys %positions;
  deblog("$i operators processed, plus initial position");
  deblog("result=$d");
  return($d);
}

#** "MAIN"
use Test::More;

my $result;
my $in;

$in = '^v';
$result = algo_exec($in);
ok( $result == 3, "eg with robo-santa '$in' results in 3" );

$in = '^>v<';
$result = algo_exec($in);
ok( $result == 3, "eg with robo-santa '$in' results in 3" );

$in = '^v^v^v^v^v';
$result = algo_exec($in);
ok( $result == 11, "eg with robo-santa '$in' results in 11" );

Test::More::done_testing();
infolog("Tests done!");

my $data = readdata();
$result = algo_exec($data);

print $result . "\n";
