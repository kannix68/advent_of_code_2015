#!/usr/bin/perl
##
# advent of code 2015. kannix68 (@github).
# Day 5: Doesn't He Have Intern-Elves For This?

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

  # It does not contain the strings ab, cd, pq, or xy,
  # It contains at least one letter that appears twice in a row
  # It contains at least three vowels (aeiou only)
  my $result = 0;
  
  if ( !($data =~ m/(ab|cd|pq|xy)/) ) {
    my @matches = ($data =~ m/[aeiou]/g);
    if (scalar(@matches) >=3) {
      if ( $data =~ m/(\w)\1/ ) {
        main::infolog("$data is a nice word. " . scalar(@matches) . " vowels, double $1");
        $result = 1;
      } else {
        main::deblog("$data no double letters");
      }
    } else {
      main::deblog("$data no 3 vowels contained");
    }
  } else {
    main::deblog("$data contains dirty syllable");
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

$in = 'ugknbfddgicrmopn';
$result = $algo->exec($in);
ok( $result == 1, "'$in' is nice" );

$in = 'aaa';
$result = $algo->exec($in);
ok( $result == 1, "'$in' is nice" );

$in = 'jchzalrnumimnmhp';
$result = $algo->exec($in);
ok( $result == 0, "'$in' is naughty" );

$in = 'haegwjzuvuyypxyu';
$result = $algo->exec($in);
ok( $result == 0, "'$in' is naughty" );

$in = 'dvszwmarrgswjxmb';
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
