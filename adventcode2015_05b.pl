#!/usr/bin/perl
##
# Advent of code 2015. kannix68 (@github).
# day 05

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

sub readdata_array() {
  my $infile = getdatafile();
  
  my @list = ();
  # multiple line input
  open(DATAFP, $infile)
    or die($!);
  while (my $data = <DATAFP>) {
    $data =~ s/(\x0D)?\x0A$//; # get rid of lineending
    push(@list, $data);
  }
  close(DATAFP);
  main::deblog("list data is size=" . scalar(@list) . ", first=>" . $list[0] . "<.");
  return(@list);
}

###############
# package for our algorithm
package Algo;

use English;

sub new {
  return bless {}, shift;
}

sub exec($) {
  my ($self, $data) = @ARG;

  # requirements:
  # It contains a pair of any two letters that appears at least twice in the string without overlapping,
  # It contains at least one letter which repeats with exactly one letter between them
  my $result = 0;
  
  if ($data =~ m/(\w{2})\w*?\1/) {
    my $sinfo = "$1";
    if ($data =~ m/((\w)\w\2)/) {
      $sinfo .= ", $2 ($1)";
       main::infolog("$data is a nice word. $sinfo");
       $result = 1;
     } else {
       main::deblog("$data no letter repeating with one letter between it. $sinfo");
     }
  } else {
    main::deblog("$data contains no pair of letters twice");
  }
  return($result);
}
###############

#** "MAIN"
package main;
use Test::More;

my $algo = Algo->new();
my $result;
my $in;

$in = 'qjhvhtzxzqqjkmpb';
$result = $algo->exec($in);
ok( $result == 1, "'$in' is nice" );

$in = 'xxyxx';
$result = $algo->exec($in);
ok( $result == 1, "'$in' is nice" );

$in = 'uurcxstgmygtbstg';
$result = $algo->exec($in);
ok( $result == 0, "'$in' is naughty" );

$in = 'ieodomkazucvgmuy';
$result = $algo->exec($in);
ok( $result == 0, "'$in' is naughty" );

Test::More::done_testing();
infolog("Tests done!");

my @data_list = readdata_array();

my $sum = 0;
foreach my $data (@data_list) {
  $result = $algo->exec($data);
  $sum += $result;
}

print($sum . "\n");
exit();
