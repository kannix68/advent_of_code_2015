#!/usr/bin/perl
##
# advent of code 2015. kannix68 (@github).
# day 01

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

# our algorithm
sub algo_exec($) {
  my $data = shift();
  my $floor_num = 0;
  my $i;
  for($i=1; $i <= length($data); $i++) {
    my $c = substr($data, $i-1, 1);
    if ($c eq '(') {
      $floor_num++;
    } elsif ($c eq ')') {
      $floor_num--;
    } else {
      print STDERR "$!, input error on >$c<.";
      die "input error";
    }
    if ( $floor_num == -1 ) {
      infolog("[b] criterium met, postition=$i, floor num=$floor_num");
      last;
    }
  }
  deblog("$i operators processed");
  deblog("resulting floor=$floor_num");
  return $i;
}

#** "MAIN"
use Test::More;

my $result;
my $in;

$in = ')';
$result = algo_exec($in);
ok( $result == 1, "'$in' results in 1 op: $result" );

$in = ')))';
$result = algo_exec($in);
ok( $result == 1, "'$in' results in 1 op: $result" );

$in = '()())';
$result = algo_exec($in);
ok( $result == 5, "'$in' results in 1 op: $result" );

my $data = readdata();
$result = algo_exec($data);

print $result . "\n";
