#
##
# advent of code 2015.
# Day 22
# Part [B]
#
# Perl 5 code
#
require 5;
use strict;
use warnings;

use Data::Dumper;

my $LOG_LEVEL = 1;
my $MAX_ROUNDS = 13;
my $PLAYER_START_MANA = 500;

my $PLAYER_START_HP = 50;

my $BOSS_START_HP = 71;
my $BOSS_DMG = 10;

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
    print STDERR "T: " . shift() . "\n";
  }
}
sub deblog($) {
  if ($LOG_LEVEL > 0) {
    print STDERR "D: " . shift() . "\n";
  }
}
sub infolog($) {
  print STDERR "I: " . shift() . "\n";
}
sub outlog($) {
  print shift() . "\n";
}

## end "lib"
######################################

#** our data
#$spells = ["Magic Missile", "Drain", "Shield", "Poison", "Recharge"]
my @spells      = ('M', 'D', 'S', 'P', 'R');
#my @spell_costs = ( 53,  73, 113, 173, 229);
my %spell_costs = ( 'M' => 53, 'D' => 73, 'S' => 113, 'P' => 173, 'R' => 229 );

my $start_tms = scalar(localtime);
my $start_tm = time();

my @games_lvl = ();
my $lvl = 0;

#** subs
sub can_cast_fx($) {
  my $s = shift();
  my $lidx = length($s)-1;
  my $sp_last = substr($s,$lidx,1);
  if ($sp_last eq 'M' or $sp_last eq 'D') {
    return 1;
  }
  if ($lidx == 0) {
    return 1;
  } elsif ($lidx == 1) {
    my $sp1 = substr($s,$lidx-1,1);
    if ($sp_last ne $sp1) {
      return 1;
    }
  } else {
    # round >= 3
    my $sp1 = substr($s,$lidx-1,1);
    my $sp2 = substr($s,$lidx-2,1);
    if ($sp_last ne $sp1 and $sp_last ne $sp2) {
      return 1;
    }
  }
  #tracelog("  forbidden cast $s") unless $LOG_LEVEL < 2;
  return 0;
}

sub can_cast_mana($) {
  my $s = shift();
  my $mana = $PLAYER_START_MANA;
  my $recharge_ct = 0;
  foreach my $sp (split('', $s)) {
    #tracelog("mana=$mana; sp=$sp; cost=".$spell_costs{$sp});
    $mana -= $spell_costs{$sp};
    if ($mana < 0) {
      return 0;
    }
    if ($sp eq 'R') {
      $recharge_ct = 2;
      $mana += 101*2;
    } elsif ($recharge_ct == 2) {
      $recharge_ct = 1;
      $mana += 101*2;
    } elsif ($recharge_ct == 1) {
      $recharge_ct = 0;
      $mana += 101;
    }
  }
  return 1;
}

sub cost_for($) {
  my $s = shift();
  my $cost = 0;
  foreach my $sp (split('', $s)) {
    $cost += $spell_costs{$sp};
  }
  return $cost;
}

##
# Play a game for a given cast sequence.
sub play_game($) {
  my $spellseq = shift();
  my $numspells = length($spellseq);
  my $finished = 0;
  my $won = 0;
  my $recharge_ct = 0;
  my $poison_ct = 0;
  my $shield_ct = 0;
  my $round = 0;
  my $turn = 0;

  my $player_hp = $PLAYER_START_HP;
  my $player_mana = $PLAYER_START_MANA;
  my $player_armr = 0;
  my $boss_hp = $BOSS_START_HP;
  my $boss_dmg = $BOSS_DMG;
  
  tracelog("start game player(hp=$player_hp, mana=$player_mana); boss(hp=$boss_hp, dmg=$boss_dmg)")
    unless $LOG_LEVEL < 2;

  while(not $finished and $turn <= $numspells*2-1) {
    $turn++;
    my $sadd;
    if ($turn % 2 == 1) {
      $round++;
      $sadd = "; player turn.";
    } else {
      $sadd = "; boss turn.";
    }
    if ($LOG_LEVEL > 1) {
      tracelog("turn $turn round $round$sadd");
      tracelog("  pl-hp=$player_hp; pl-mana=$player_mana; ct=(shld:$shield_ct, psn:$poison_ct, rchrg:$recharge_ct)");
      tracelog("  boss-hp (before all)=$boss_hp");
    }
    if ($recharge_ct > 0){
      $recharge_ct--;
      $player_mana += 101;
      tracelog("    recharge provides 101 mana, tick=$recharge_ct")
        unless $LOG_LEVEL < 2;
    }
    if ($shield_ct > 0){
      $shield_ct--;
      $player_armr = 7;
      tracelog("    shield increases armor to 7, tick=$shield_ct")
        unless $LOG_LEVEL < 2;
    } else {
      $player_armr = 0;
    }
    if ($poison_ct > 0){
      $poison_ct--;
      $boss_hp -= 3;
      tracelog("    poison decreases boss hp to $boss_hp, tick=$poison_ct")
        unless $LOG_LEVEL < 2;
    }
    if ($boss_hp < 1) {
      deblog("boss killed by fx; ret=$turn; spellseq=$spellseq.");
      return $turn;
    }
    if ($turn % 2 == 1) {
      # PLAYER turn
      tracelog("  pl-hp=$player_hp; pl-mana=$player_mana; ct=(shld:$shield_ct, psn:$poison_ct, rchrg:$recharge_ct)")
        unless $LOG_LEVEL < 2;
      ## PART B
      $player_hp -= 1;
      if ($player_hp < 1) {
        $turn *= -1;
        deblog("player killed by lvl hard; ret= $turn; spellseq=$spellseq.");
        return $turn;
      }
      ##
      #deblog("rd=$round; spellseq=$spellseq");
      my $spell = substr($spellseq, $round-1, 1);
      if ($spell eq 'M') {
        $player_mana -= 53;
        $boss_hp -= 4;
      } elsif ($spell eq 'D') {
        $player_mana -= 73;
        $boss_hp -= 2;
        $player_hp += 2;
      } elsif ($spell eq 'S') {
        $player_mana -= 113;
        $shield_ct = 6;
      } elsif ($spell eq 'P') {
        $player_mana -= 173;
        $poison_ct = 6;
      } elsif ($spell eq 'R') {
        $player_mana -= 229;
        $recharge_ct = 5;
      } else {
        die("unknown spell >$spell<");
      }
      if ($LOG_LEVEL > 1) {
        tracelog("  player casts $spell;  pl-mana=$player_mana");
        tracelog("  boss-hp (after all)=$boss_hp");
      }
      # if player out of mana
      if ( $player_mana < 0 ) {
        deblog("impossible spellsequence, player out of mana; ret=-9999; spellseq=$spellseq.");
        return -9999; # OOM
      }
      # if boss dies
      if ( $boss_hp < 0 ) {
        deblog("boss killed by dmg; ret=$turn; spellseq=$spellseq.");
        return $turn;
      }
    } else {
      # BOSS turn
      my $dmg = $boss_dmg - $player_armr;
      if ($dmg < 1){
        $dmg = 1;
      }
      $player_hp -= $dmg;
      if ($LOG_LEVEL == 2) {
        tracelog("  boss damages for: $dmg hp;  $boss_dmg - $player_armr");
        tracelog("  pl-hp=$player_hp; pl-mana=$player_mana; ct=(shld:$shield_ct, psn:$poison_ct, rchrg:$recharge_ct)");
        tracelog("  boss-hp (no change)=$boss_hp");
      }
      # if player dies
      if ( $player_hp < 0 ) {
        $turn *= -1;
        deblog("player killed by dmg; ret= $turn; spellseq=$spellseq.");
        return $turn;
      }
    }
  } # end while
  deblog("out of (finished) turns; incomplete game; ret=0; spellseq=$spellseq.");
  return 0;
}

#** MAIN

# testing
# TESTING 1
$LOG_LEVEL = 1;
$MAX_ROUNDS = 4;
$PLAYER_START_HP = 10;
$PLAYER_START_MANA = 250;
$BOSS_START_HP = 13;
$BOSS_DMG = 8;

my $casts = 'PM';
my $r = play_game($casts);
infolog("testing1 res=$r");
##exit(-1);


# TESTING 2
$BOSS_START_HP = 14;
$casts = 'RSDPM';
$r = play_game($casts);
infolog("testing2 res=$r");

##exit(-1);
# END testing
#!!!!!!
################################################

#** MAIN query
infolog("PRODUCTION begins");

$LOG_LEVEL = 0;
$MAX_ROUNDS = 13+4;
$PLAYER_START_MANA = 500;

$PLAYER_START_HP = 50;

$BOSS_START_HP = 71;
$BOSS_DMG = 10;

push @games_lvl, [''];
deblog("gameslvl=".Dumper(\@games_lvl));

my @gameswon = ();
my $ovcount=0;
while( $lvl < $MAX_ROUNDS ) {
  $lvl++;
  push @games_lvl, [];
  my $lastlvl = $lvl - 1;
  my $lastgames = $games_lvl[$lastlvl];
  my $thisgames = $games_lvl[$lvl];
  deblog("lvl=$lvl; num lastlvl games=".scalar(@$lastgames));
  tracelog("lastlvlgames=".Dumper($lastgames)) unless $LOG_LEVEL < 2;
  my $lvlcount = 0;
  my $acccount = 0;
  my $nofxcount = 0;
  my $nomncount = 0;
  my $diecount = 0;
  for (my $lastlvlidx = 0; $lastlvlidx < scalar(@$lastgames); $lastlvlidx++) {
    my $gmstat = $lastgames->[$lastlvlidx];
    tracelog("lvl=$lvl; oloop $lastlvlidx; prev gmstat=>$gmstat<.") unless $LOG_LEVEL < 2;
    foreach my $lspell (@spells) {
      $ovcount++;
      $lvlcount++;
      my $newgmstat = $gmstat.$lspell;
      tracelog("  spl=$lspell; ##=$ovcount, #=$lvlcount ; seq=$newgmstat") unless $LOG_LEVEL < 2;
      if (can_cast_fx($newgmstat)) {
        if (can_cast_mana($newgmstat)) {
          my $pret = play_game($newgmstat);
          if ($pret > 0){
            infolog("player game WON: gameseq >$newgmstat<");
            push @gameswon, $newgmstat;
          } elsif ($pret == 0) {
            deblog("push unfinished play: gameseq >$newgmstat<") unless $LOG_LEVEL < 1;
            push @$thisgames, $newgmstat;
            $acccount++;
          } else {
            deblog("  player game LOST: gameseq >$newgmstat<") unless $LOG_LEVEL < 1;
          }
        } else {
          $nomncount++;
          deblog("no mana for spell cast $newgmstat") unless $LOG_LEVEL < 1;
        }
      } else {
        $nofxcount++;
        #deblog("forbidden fx spell cast $newgmstat");
      }
    }
  }
  infolog("lvl=$lvl DONE after ".(time()-$start_tm)." secs. num thislvl games=".scalar(@$thisgames));
  infolog("  overall#=$ovcount; lvl#=$lvlcount; accepted#=$acccount; nofx#=$nofxcount; nomana#=$nomncount; died#=$diecount");
}

my $num_gameswon = scalar(@gameswon);
infolog($num_gameswon." won games after lvl=$MAX_ROUNDS");

my @sgames = sort { cost_for($a) <=> cost_for($b) } @gameswon;
foreach my $gam (@sgames) {
  infolog("wongame: $gam; cost=".cost_for($gam));
}

if ($num_gameswon == 0) {
  infolog("TESTING gameswon");
  @gameswon = ('MMMM', 'R', 'DD', 'MP', 'SM');
  infolog($num_gameswon." won games after lTESTING");
  
  my @sgames = sort { cost_for($a) <=> cost_for($b) } @gameswon;
  foreach my $gam (@sgames) {
    infolog("won-testig-game: $gam; cost=".cost_for($gam));
  }
}

__END__
