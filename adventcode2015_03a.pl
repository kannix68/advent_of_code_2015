#!/bin/perl
##
# advent of code 2015. kannix68 (@github).
# Day 3: Perfectly Spherical Houses in a Vacuum.

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
  my $x_pos = 0;
  my $y_pos = 0;
  my %positions;
  
  # starting position is delivered/added:
  $positions{"${x_pos},${y_pos}"}++;
  deblog("num keys=1; key=0,0; value=1");
  for($i=0; $i < length($data); $i++) {
    my $c = substr($data, $i, 1);
    if ($c eq '>') {
      $x_pos++;
    } elsif ($c eq '<') {
      $x_pos--;
    } elsif ($c eq '^') {
      $y_pos++;
    } elsif ($c eq 'v') {
      $y_pos--;
    } else {
      print STDERR "$!, input error on >$c<.";
      die "input error";
    }
    my $k = "${x_pos},${y_pos}";
    $positions{$k}++;
    my $v = $positions{$k};
    my $d = scalar keys %positions;
    deblog("# $i: op=$c; num keys=$d; key=$k; value=$v");
    #if ( $i == 10 ) {
    #  last;
    #}
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

$in = '>';
$result = algo_exec($in);
ok( $result == 2, "eg '$in' results in 2" );

$in = '^>v<';
$result = algo_exec($in);
ok( $result == 4, "eg '$in' results in 4" );

$in = '^v^v^v^v^v';
$result = algo_exec($in);
ok( $result == 2, "eg '$in' results in 2" );

Test::More::done_testing();
infolog("Tests done!");

my $data = readdata();
$result = algo_exec($data);

print $result . "\n";
