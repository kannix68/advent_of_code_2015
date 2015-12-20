#!/usr/bin/ruby
##
# advent of code 2015. kannix68.
# Day 12: JSAbacusFramework.io
#

$:.unshift File.dirname(__FILE__)
require 'aocbase.rb' # < helpers class

#** our algorithm

class Day12Solver < AocBase
  require 'json'

  def initialize()
    super()
    @dsum = 0
  end

  def sparse(dstruct)
    deblog("dstruct class=#{dstruct.class}.")
    if dstruct.is_a?(Hash)
      dstruct.each do |k,v|
        sparse(v)
      end
    elsif dstruct.is_a?(Array)
      dstruct.each do |elem|
        sparse(elem)
      end
    elsif dstruct.is_a?(Numeric)
      deblog("adding #{dstruct}.")
      @dsum += dstruct
    else
      deblog("  no action.")
    end
  end

  def algo_exec(ins)
    @dsum = 0
    deblog("algo_exec() input = >#{ins}<.")
    dstruct = JSON.parse(ins)
    deblog("dstruct class=#{dstruct.class}.")
    sparse(dstruct)
    tmp = @dsum
    infolog("algo returns #{@dsum}")
    return(tmp)
  end
end # class DayXXSolver

#** "MAIN", including unit tests

require 'test/unit'
class Test01Examples < Test::Unit::TestCase
  def test_example_01
    day12solver = Day12Solver.new
    day12solver.log_level = 2
    day12solver.infolog("day12solver instantiated")
    s = '[1,2,3]'
    isum = day12solver.algo_exec(s)
    assert_equal( 6, isum, "example #{s} invalid" )

    s = '{"a":2,"b":4}'
    isum = day12solver.algo_exec(s)
    assert_equal( 6, isum, "example #{s} invalid" )
  end
  def test_example_02
    day12solver = Day12Solver.new
    day12solver.log_level = 2
    s = '[[[3]]]'
    isum = day12solver.algo_exec(s)
    assert_equal( 3, isum, "example #{s} invalid" )

    s = '{"a":{"b":4},"c":-1}'
    isum = day12solver.algo_exec(s)
    assert_equal( 3, isum, "example #{s} invalid" )
  end
  def test_example_03
    day12solver = Day12Solver.new
    day12solver.log_level = 2
    s = '{"a":[-1,1]}'
    isum = day12solver.algo_exec(s)
    assert_equal( 0, isum, "example #{s} invalid" )

    s = '[-1,{"a":1}]'
    isum = day12solver.algo_exec(s)
    assert_equal( 0, isum, "example #{s} invalid" )
  end
  def test_example_04
    day12solver = Day12Solver.new
    day12solver.log_level = 2
    s = '[]'
    isum = day12solver.algo_exec(s)
    assert_equal( 0, isum, "example #{s} invalid" )

    s = '{}'
    isum = day12solver.algo_exec(s)
    assert_equal( 0, isum, "example #{s} invalid" )
  end
end # class

class Test02Solution < Test::Unit::TestCase
  def test_solution_1
    day12solver = Day12Solver.new
    day12solver.log_level = 1
    ins = day12solver.readdata()
    assert( !ins.nil? && ins != '', "data file read" )
    day12solver.infolog("data=#{ins}")
    res = day12solver.algo_exec(ins)
    assert( !res.nil? && res != 0, "result" )
    puts "RESULT=#{res}"

  end
end

puts "program ends."

__END__

[1,2,3] and {"a":2,"b":4} both have a sum of 6.
[[[3]]] and {"a":{"b":4},"c":-1} both have a sum of 3.
{"a":[-1,1]} and [-1,{"a":1}] both have a sum of 0.
[] and {} both have a sum of 0.
