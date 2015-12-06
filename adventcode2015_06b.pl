#!/usr/bin/perl
##
# Advent of code 2015. kannix68 (@github).
# Day 6: Probably a Fire Hazard.

require 5;
use strict;
use warnings;
use English;

my $DEBLOG = 1;  # 0|1

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

my @lights_mat;
my $dim = 1000;

sub new {
  # initialize data structure
  @lights_mat = ();
  for(my $i = 0; $i < $dim; $i++) {
    my $row = [];
    for(my $j = 0; $j < $dim; $j++) {
      push @$row, 0;
    }
    push @lights_mat, $row;
  }  
  main::deblog("lights initialized, 1 dimension=$dim");
  #main::deblog("lights[0,0]=".$lights_mat[0][0]);
  #main::deblog("lights[dim-1,dim-1]=".$lights_mat[$dim-1][$dim-1]);
  #use Data::Dumper; print Dumper(\@lights_mat); exit;

  return bless {}, shift;
}

sub operate($) {
  my ($self, $op) = @ARG;
  if ( $op =~ m/^turn on (\d+),(\d+) through (\d+),(\d+)$/ ) {
    # turn on 0,0 through 999,999
    my ($xmin, $ymin, $xmax, $ymax) = ($1, $2, $3, $4);
    for(my $i = $xmin; $i <= $xmax; $i++) {
      for(my $j = $ymin; $j <= $ymax; $j++) {
        $lights_mat[$i][$j] += 1;
        #main::deblog("turned light[$i,$j] on");
      }
    }
    main::deblog("inc-1 " . (($xmax-$xmin+1)*($ymax-$ymin+1)) . " lights: $xmin,$ymin : $xmax,$ymax");
  } elsif ($op =~ m/^turn off (\d+),(\d+) through (\d+),(\d+)$/) {
    # turn off 499,499 through 500,500
    my ($xmin, $ymin, $xmax, $ymax) = ($1, $2, $3, $4);
    for(my $i = $xmin; $i <= $xmax; $i++) {
      for(my $j = $ymin; $j <= $ymax; $j++) {
        $lights_mat[$i][$j] -= 1;
        if ($lights_mat[$i][$j] < 0) {
          $lights_mat[$i][$j] = 0;
        }
      }
    }
    main::deblog("dec-1 " . (($xmax-$xmin+1)*($ymax-$ymin+1)) . " lights: $xmin,$ymin : $xmax,$ymax");
  } elsif ($op =~ m/^toggle (\d+),(\d+) through (\d+),(\d+)$/) {
    # toggle 0,0 through 999,0
    my ($xmin, $ymin, $xmax, $ymax) = ($1, $2, $3, $4);
    for(my $i = $xmin; $i <= $xmax; $i++) {
      for(my $j = $ymin; $j <= $ymax; $j++) {
        $lights_mat[$i][$j] += 2;
      }
    }
    main::deblog("inc-2 " . (($xmax-$xmin+1)*($ymax-$ymin+1)) . " lights: $xmin,$ymin : $xmax,$ymax");
  } else {
    die("proccessing error on $op");
  }
}

sub exec() {
  my ($self) = @ARG;
  my $result = 0;

  # count
  my $sum = 0;
  for(my $i = 0; $i < $dim; $i++) {
    for(my $j = 0; $j < $dim; $j++) {
      $sum += $lights_mat[$i][$j];
      #if ($lights_mat[$i][$j] > 0) {
      #  main::deblog("light[$i,$j] is on");
      #}
    }
  }
  $result = $sum;
  return($result);
}
###############

#** "MAIN"
package main;
use Test::More;

my $algo = Algo->new();
my $result;
my $in;

$in = '';
$result = $algo->exec();
ok( $result == 0, "initial is empty" );

$algo->operate("turn on 0,0 through 0,0");
$result = $algo->exec();
ok( $result == 1, "shine one light; $result" );

$algo->operate("toggle 0,0 through 999,999");
$result = $algo->exec();
ok( $result == 1+2000000, "shine all  via toggling; $result" );

$algo = Algo->new();
$algo->operate("turn off 0,0 through 0,0");
$result = $algo->exec();
ok( $result == 0, "no lights; $result" );

$algo->operate("turn on 0,0 through 0,0");
$result = $algo->exec();
ok( $result == 1, "shine one light; $result" );

$algo->operate("turn on 0,0 through 0,0");
$result = $algo->exec();
ok( $result == 2, "shine one light brt; $result" );

$algo->operate("turn off 0,0 through 0,0");
$result = $algo->exec();
ok( $result == 1, "light 1 to normal; $result" );

$algo->operate("turn off 0,0 through 0,0");
$result = $algo->exec();
ok( $result == 0, "no more lights; $result" );

$algo->operate("turn off 0,0 through 0,0");
$result = $algo->exec();
ok( $result == 0, "still no lights; $result" );

Test::More::done_testing();
infolog("Tests done!");

$algo = Algo->new();
my @data_list = readdata_array();

my $count = 0;
foreach my $data (@data_list) {
  $count++;
  $result = $algo->operate($data);
}
infolog("$count operations done.");
$result = $algo->exec();

print($result . "\n");
exit();
