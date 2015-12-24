#
##
# advent of code 2015.
# Day 20
# Part [B]
#
# Perl 5 code
#
require 5;
use strict;
use warnings;

use Data::Dumper;

my $LOG_LEVEL = 0;

######################################
## start "lib"

# initialize Data::Dumper
$Data::Dumper::Indent = 0;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Terse = 1;
$Data::Dumper::Sortkeys = sub {
    no warnings 'numeric';
    [ sort { $a <=> $b } keys %{$_[0]} ]
};
##

#** subs
sub tracelog($) {
  if ($LOG_LEVEL > 1) {
    print STDERR "T:" . shift() . "\n";
  }
}
sub deblog($) {
  if ($LOG_LEVEL > 0) {
    print STDERR "D:" . shift() . "\n";
  }
}
sub infolog($) {
  print STDERR "I:" . shift() . "\n";
}
sub outlog($) {
  print shift() . "\n";
}

## end "lib"
######################################
# Me / Player
my $player_hp = 100;

#Boss:
#Hit Points: 104
#Damage: 8
#Armor: 1
my $boss_hp = 104;
my $boss_dmg = 8;
my $boss_armr = 1;

# exactly one weapon
# 0-1 armor
# 0-2 rings (only one each)

my $dummy = <<DUMMY;
Weapons:    Cost  Damage  Armor
Dagger        8     4       0
Shortsword   10     5       0
Warhammer    25     6       0
Longsword    40     7       0
Greataxe     74     8       0

Armor:      Cost  Damage  Armor
Leather      13     0       1
Chainmail    31     0       2
Splintmail   53     0       3
Bandedmail   75     0       4
Platemail   102     0       5

Rings:      Cost  Damage  Armor
Damage +1    25     1       0
Damage +2    50     2       0
Damage +3   100     3       0
Defense +1   20     0       1
Defense +2   40     0       2
Defense +3   80     0       3
DUMMY

my @weapons     = ( "Dagger", "Shortsword", "Warhammer", "Longsword", "Greataxe");
my @weapon_cost = ( 8, 10, 25, 40, 74);
my @weapon_dmg  = ( 4,  5,  6,  7,  8);

my @armors      = ( "<no armor>", "Leather", "Chainmail", "Splintmail", "Bandedmail", "Platemail");
my @armor_cost  = (0, 13, 31, 53, 75, 102);
my @armor_armr  = (0,  1,  2,  3,  4,   5);

my @rings     = ( "<no ring>", "Damage+1", "Damage+2", "Damage+3", "Defense+1", "Defense+2", "Defense+3" );
my @ring_cost = (0, 25, 50,100, 20, 40, 80);
my @ring_dmg  = (0,  1,  2,  3,  0,  0,  0);
my @ring_armr = (0,  0,  0,  0,  1,  2,  3);

my $start_tms = scalar(localtime);
my $start_tm = time();

##** combine all
my $combis = 0;
my @player_setups = ();
for (my $weapon = 0; $weapon <= $#weapons; $weapon++) {
  # have a $weapon
  for (my $armor = 0; $armor <= $#armors; $armor++) {
    # $have some $armor
    for (my $ring_left = 0; $ring_left <= $#rings; $ring_left++) {
      # have some $left_ring
      for (my $ring_right = 0; $ring_right <= $#rings; $ring_right++) {
        if ( $ring_right != 0 && $ring_right == $ring_left ) {
          # unique rings!
          next;
        }
        # have some $right_ring
        my $combi = $weapons[$weapon] . ':' . $armors[$armor] . ':' . $rings[$ring_left] . ':' . $rings[$ring_right];
        my $combi_cost = $weapon_cost[$weapon] + $armor_cost[$armor] + $ring_cost[$ring_left] + $ring_cost[$ring_right];
        my $combi_dmg = $weapon_dmg[$weapon] + $ring_dmg[$ring_left] + $ring_dmg[$ring_right];
        my $combi_armr = $armor_armr[$armor] + $ring_armr[$ring_left] + $ring_armr[$ring_right];
        $combis++;
        tracelog("combi # $combis: $combi cost=$combi_cost, dmg=$combi_dmg, armr=$combi_armr");
        push @player_setups, [$combi, $combi_cost, $combi_dmg, $combi_armr];
      }
    }
  }
}
my $name_idx = 0;
my $cost_idx = 1;
my $dmg_idx = 2;
my $armr_idx = 3;
@player_setups = sort { $a->[$cost_idx] <=> $b->[$cost_idx] } @player_setups;
my $tmps = Dumper(\@player_setups);
$tmps =~ s/\[/\n\[/g;
deblog("player setups=" . $tmps);

my $elapsed_tm = time() - $start_tm;
outlog("finished! elapsed=$elapsed_tm secs from $start_tms");

sub play_out($$) {
  my $player = shift();
  my $boss = shift();
  deblog("player=".Dumper($player)."; boss=".Dumper($boss));
  
  # player starts
  # damage = dmg - oppenent-armr, at least 1
  my $round = 0;
  my $dmg;
  my $won = undef;
  while( $player->[0] > 0 && $boss->[0] > 0 ) {
    $round++;
    my $attacker = $player;
    my $opponent = $boss;
    #-tracelog("attacker=".Dumper($attacker)."; opponent=".Dumper($opponent));
    $dmg = $attacker->[1] - $opponent->[2];
    if ( $dmg <= 0 ) {
      $dmg = 1;
    }
    $opponent->[0] -= $dmg;
    tracelog("rd=$round: player deals dmg=$dmg; boss hp=".$opponent->[0]);
    if ($opponent->[0] <= 0) {
      $won = 1;
      last;
    }
    $attacker = $boss;
    $opponent = $player;
    $dmg = $attacker->[1] - $opponent->[2];
    if ( $dmg <= 0 ) {
      $dmg = 1;
    }
    $opponent->[0] -= $dmg;
    tracelog("rd=$round: boss deals dmg=$dmg; player hp=".$opponent->[0]);
    if ($opponent->[0] <= 0) {
      $won = 0;
      last;
    }
  }
  my $res = $round;
  if ( !$won ) {
    $res *= -1;
  }
  deblog("result=$res; battle won?=$won after round $round");
  return($res);
}

infolog("testing");
my $testres = play_out( [8,5,5], [12,7,2] );
infolog("test result=$testres");

infolog("..PLAYING...:");

#my $name_idx = 0;
#my $cost_idx = 1;
#my $dmg_idx = 2;
#my $armr_idx = 3;
my $res;
my $winning_setup;
foreach my $player_setup (@player_setups) {
  deblog("battling player-setup=" . Dumper($player_setup) . " cost=" . $player_setup->[$cost_idx]);
  my $player = [$player_hp, $player_setup->[$dmg_idx], $player_setup->[$armr_idx] ];
  my $boss = [$boss_hp, $boss_dmg, $boss_armr];
  $res = play_out($player, $boss);
  deblog("  res=$res");
  if ( $res > 0 ) {
    $winning_setup = $player_setup;
    last;
  }
}
infolog("cost=" . $winning_setup->[$cost_idx] . " for winning setup: " . $winning_setup->[$name_idx] );

$LOG_LEVEL = 1;
@player_setups = reverse @player_setups;
my $tmps = Dumper(\@player_setups);
$tmps =~ s/\[/\n\[/g;
deblog("player setups=" . $tmps);
my $losing_setup;
foreach my $player_setup (@player_setups) {
  deblog("battling player-setup=" . Dumper($player_setup) . " cost=" . $player_setup->[$cost_idx]);
  my $player = [$player_hp, $player_setup->[$dmg_idx], $player_setup->[$armr_idx] ];
  my $boss = [$boss_hp, $boss_dmg, $boss_armr];
  $res = play_out($player, $boss);
  deblog("  res=$res");
  if ( $res < 0 ) {
    $losing_setup = $player_setup;
    last;
  }
}
infolog("cost=" . $losing_setup->[$cost_idx] . " for most expensive losing setup: " . $losing_setup->[$name_idx] );

__END__
For example, suppose you have 8 hit points, 5 damage, and 5 armor, and that the boss has 12 hit points, 7 damage, and 2 armor:

    The player deals 5-2 = 3 damage; the boss goes down to 9 hit points.
    The boss deals 7-5 = 2 damage; the player goes down to 6 hit points.
    The player deals 5-2 = 3 damage; the boss goes down to 6 hit points.
    The boss deals 7-5 = 2 damage; the player goes down to 4 hit points.
    The player deals 5-2 = 3 damage; the boss goes down to 3 hit points.
    The boss deals 7-5 = 2 damage; the player goes down to 2 hit points.
    The player deals 5-2 = 3 damage; the boss goes down to 0 hit points.


