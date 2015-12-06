#!/usr/bin/perl
##
# advent of code 2015. kannix68 (@github).
# Day 2: I Was Told There Would Be No Math.

require 5;
use strict;
use warnings;
use English;

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

sub algo_operate($) {
  my $data = shift();
  if ( not ($data =~ m/^(\d+)x(\d+)x(\d+)$/) ){
    print STDERR "$!, input error on >$data<.";
    die "input error";
  }
  my ($x, $y, $z) = ($1+0, $2+0, $3+0);
  my @sorted_sides = sort {$a <=> $b} ($x, $y, $z); # sort numerically!
  my $min = $sorted_sides[0];
  my $mid = $sorted_sides[1];
  #deblog("x=$x, y=$y, z=$z; min=$min, mid=$mid");

  # formula wrap: 2*l*w + 2*w*h + 2*h*l
  my $a_wrap = 2*$x*$y + 2*$x*$z + 2*$y*$z;
  # formula extra: area of smallest side
  my $a_xtra = $min*$mid;
  #deblog("a_wrap=$a_wrap, a_xtra=$a_xtra");
  return($a_wrap+$a_xtra);
}

# our algorithm
sub algo_exec($) {
  my $infile = getdatafile();
  my $line_num = 0;
  my $a_sum = 0;
  # multi line input
  open(DATAFP, $infile)
    or die($!);
  while (my $dataline =  <DATAFP>) {
    $dataline =~ s/(\x0D)?\x0A//; # get rid of lineending
    $line_num++;
    $a_sum += algo_operate($dataline);
  }
  close(DATAFP);
  return($a_sum);
}

#** "MAIN"
use Test::More;

my $result;
my $in;

$in = '2x3x4';
$result = algo_operate($in);
ok( $result == 58, " eg parcel 1 '$in' results in 58" );

$in = '1x1x10';
$result = algo_operate($in);
ok( $result == 43, " eg parcel 2 '$in' results in 45" );

Test::More::done_testing();
infolog("Tests done!");

my $data = readdata();
$result = algo_exec($data);

print $result . "\n";
