#!/bin/perl
##
# advent of code 2015. kannix68 (@github).
# Day 4: The Ideal Stocking Stuffer.
# Part [B]

require 5;
use strict;
use warnings;
use English;

my $DEBLOG = 1;  # 0|1

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

sub readdata() {
  deblog("basename=$0\n");
  my $infile = $0;
  $infile =~ s/^(?:\.\/)?(adventcode2015_)(.*?)[a-z]?\.pl$/$1in$2\.txt/;
  deblog("data filename=$infile\n");
  
  # one line input
  open DATAFP, $infile
    or die $!;
  my $data =  <DATAFP>;
  close(DATAFP);
  $data =~ s/(\x0D)?\x0A$//; # get rid of lineending
  main::deblog("data is len=" . length($data) . ", >$data<.");
  return($data);
}

###############
#** our algorithm

package Algo;

use English;
use Digest::MD5 qw(md5_hex);

sub new {
  return bless {}, shift;
}

sub exec($$) {
  my ($self, $criterium, $data) = @ARG;

  my $hsecret = $data;
  main::deblog("hash secret is $hsecret");
  my $sl = length($criterium);

  my $payload = 0;
  while ( 1 ) {
    $payload++;
    if ( ($payload % 1000) == 0 ) {
      print STDERR '.';
    }
    my $digest = md5_hex($hsecret.$payload);
    if ( substr($digest, 0, $sl) eq $criterium ) {
      print STDERR "\n";
      main::infolog("criterium found!");
      main::infolog("  payload=$payload; md5-hex-digest=$digest; data=" . $hsecret.$payload);
      last;
    }
  }
  return($payload);
}
###############

#** "MAIN"
package main;
use Test::More;

my $data = readdata();
my $algo = Algo->new();
my $result;

#Test::More::done_testing();
infolog("NO Tests done (because no tests given)!");

$result = $algo->exec('000000', $data);

print($result . "\n");
