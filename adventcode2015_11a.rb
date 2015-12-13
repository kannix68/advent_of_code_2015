#!/usr/bin/ruby
##
# advent of code 2015. kannix68.
# Day 11: Corporate Policy
#
# About the algorithm: Too straight-forward and long.


$:.unshift File.dirname(__FILE__)
require 'aocbase.rb' # < helpers class

#** our algorithm

class Day11Solver <AocBase
  def initialize()
    super()
    @v_seqs = []
    for num in ('a'.ord) .. ('x'.ord)
      @v_seqs.push(num.chr + (num+1).chr + (num+2).chr)
    end
    #tracelog("vaid_seqs #{@v_seqs}")
  end

  def isvalid(ins)
    tracelog("isvalid() input = >#{ins}<.")
    if ins.length !=8
      tracelog( "length #{ins.length} invalid" )
      return false
    end
    if ins =~ /[^a-z]|[iol]/
      tracelog( "invalid characters" )
      return false
    end
    seq_found = @v_seqs.any? do |seq| ins.include? seq end
    if !seq_found
      tracelog( "no triple-seq found" )
      return false
    end
    if ins =~ /(.)\1.*?(.)\2/
      deblog("isvalid()!OK input = >#{ins}<.")
      return true
    else
      tracelog( "no two pairs" )
      return false
    end
  end
  
  def incpass(ins)
    tracelog("incpass() input = >#{ins}<.")
    tmp = ins.dup
    for num in (tmp.length-1).downto(0)
      if tmp[num] != 'z'
        tracelog("inc pos #{num} >#{tmp[num]}<")
        tmp[num] = (tmp[num].ord+1).chr
        break
      else
        tracelog("shift pos #{num} >>z<<")
        tmp[num] = 'a'
      end
    end
    tracelog("next is #{tmp}")
    if match = tmp.match( /^([^iol]*)([iol])(.*)$/ )
      tracelog("  correct for dirty letters")
      g1, g2, g3 = match.captures
      r2 = (g2.ord+1).chr
      r3 = 'a'*g3.length
      tmp = g1 + r2 + r3
      tracelog("newnext is #{tmp}, #{g1} :: #{g2}>#{r2} :: #{r3}")
    end
    if tmp == ins
      raise "duality"
    end
    tmp
  end

  def nextvalid(ins)
    deblog("nextvalid() input = >#{ins}<.")
    isval = false
    ct = 0
    tmp = ins.dup
    maxiter = 999999
    while !isval && ct < maxiter
      tmp = incpass(tmp)
      tracelog("iter #{ct} #{tmp}")
      if isvalid(tmp)
        isval = true
      end
      ct += 1
    end
    deblog("found valid nextvalid pass = >#{tmp}< after #{ct} iters.")
    if ct == maxiter
      raise "ABORT maxiterations #{maxiter} touched!"
    end
    return(tmp)
  end
end # class DayXXSolver

#** "MAIN", including unit tests

require 'test/unit'
class Test01Examples < Test::Unit::TestCase
  def test_example_01
    day11solver = Day11Solver.new
    day11solver.infolog("day11solver instantiated")
    s = 'hijklmmn'
    b = day11solver.isvalid(s)
    assert_equal( b, false, "example #{s} invalid" )
  end
  def test_example_02
    day11solver = Day11Solver.new
    s = 'abbceffg'
    b = day11solver.isvalid(s)
    assert_equal( b, false, "example #{s} invalid" )
  end
  def test_example_03
    day11solver = Day11Solver.new
    s = 'abbcegjk'
    b = day11solver.isvalid(s)
    assert_equal( b, false, "example #{s} invalid" )
  end
  def test_example_05
    day11solver = Day11Solver.new
    s = 'abcdffaa'
    b = day11solver.isvalid(s)
    assert_equal( b, true, "example #{s} is valid" )
  end
  def test_example_06
    day11solver = Day11Solver.new
    s = 'ghjaabcc'
    b = day11solver.isvalid(s)
    assert_equal( b, true, "example #{s} is valid" )
  end

  def test_example_11
    day11solver = Day11Solver.new
    s = 'aa'
    exps = 'ab'
    t = day11solver.incpass(s)
    assert_equal( t, exps, "inc passwd of #{s} is #{exps}" )
  end
  def test_example_12
    day11solver = Day11Solver.new
    s = 'xy'
    exps = 'xz'
    t = day11solver.incpass(s)
    assert_equal( t, exps, "inc passwd of #{s} is #{exps}" )
  end
  def test_example_13
    day11solver = Day11Solver.new
    s = 'xz'
    exps = 'ya'
    t = day11solver.incpass(s)
    assert_equal( t, exps, "inc passwd of #{s} is #{exps}" )
  end
  def test_example_14
    day11solver = Day11Solver.new
    s = 'xzz'
    exps = 'yaa'
    t = day11solver.incpass(s)
    assert_equal( t, exps, "inc passwd of #{s} is #{exps}" )
  end

  def test_example_21
    day11solver = Day11Solver.new
    s = 'abcdefgh'
    exps = 'abcdffaa'
    t = day11solver.nextvalid(s)
    assert_equal( t, exps, "next passwd of #{s} is #{t}" )
  end
  def test_example_22
    day11solver = Day11Solver.new
    s = 'ghijklmn'
    exps = 'ghjaabcc'
    t = day11solver.nextvalid(s)
    assert_equal( t, exps,"next passwd of #{s} is #{t}" )
  end
end # class

class Test02Solution < Test::Unit::TestCase
  def test_solution_1
    day11solver = Day11Solver.new
    #day11solver.log_level = 1
    ins = day11solver.readdata()
    assert( !ins.nil? && ins != '', "data file read" )
    day11solver.infolog("data=#{ins}")
    res = day11solver.nextvalid(ins)
    assert( !res.nil? && res != '', "result" )
    puts "RESULT=#{res}"
  end
end

puts "program ends."

__END__


Passwords must include one increasing straight of at least three letters, like abc, bcd, cde, and so on, up to xyz.
They cannot skip letters; abd doesn't count.
Passwords may not contain the letters i, o, or l, as these letters can be mistaken
for other characters and are therefore confusing.
Passwords must contain at least two different,
non-overlapping pairs of letters, like aa, bb, or zz.
