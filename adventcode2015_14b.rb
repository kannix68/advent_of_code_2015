#!/usr/bin/ruby
##
# advent of code 2015. kannix68.
# Day Day 14: Reindeer Olympics
# Part [B].
#


$:.unshift File.dirname(__FILE__)
require 'aocbase.rb' # < helpers class

#** our algorithm

class Reindeer
  attr_reader :name
  attr_reader :speed
  attr_reader :go_for
  attr_reader :pause_for
  attr_reader :state

  def initialize(rname, speed, go_for, pause_for)
    super()
    @name = rname
    @speed = speed
    @go_for = go_for
    @pause_for = pause_for
    #@state = "going"
  end
  
  def to_s
    "reindeer #{@name} goes at #{@speed} kms for #{@go_for} secs and pauses for #{@pause_for} secs."
  end
  
  def dist_after_secs(t)
    t_cur = 0
    dist_cur = 0
    rstate = "going"
    while t_cur < t do
      t_delta = t - t_cur
      t_going = [t_delta, @go_for].min
      dist_cur += t_going * speed
      t_cur += go_for
      if t_cur >= t
        rstate = "going"
      else
        rstate = "resting"
        t_cur += pause_for
      end
    end
    #STDERR.puts "#{@name} after t=#{t} gone #{dist_cur} state #{rstate}"
    dist_cur
  end
end

class Day14Solver < AocBase
  attr_accessor :fn # filename

  def initialize()
    super()
  end
  
  def fileparse(fn)
    cont = readfile(fn)
    puts cont
    @athletes = []
    cont.each_line do |line|
      # Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.
      if match = line.match( /^(\w+) can fly (\d+) km\/s for (\d+) seconds?, but then must rest for (\d+) seconds?\.$/ )
        rname, speed, go_for, pause_for = match.captures
        reindeer = Reindeer.new( rname, speed.to_i, go_for.to_i, pause_for.to_i )
        puts reindeer.to_s
        @athletes.push(reindeer)
      else
        raise "unparseable line: >#{line}<"
      end
    end
  end

  def algo_exec(tmax)
    fileparse(@fn)
    max_dist = 0
    best_athlete = nil?
    deblog("algo_exec() input = >#{tmax}<.")
    deblog("athletes are #{@athletes}")
    scores = {}
    @athletes.each do |reindeer|
      scores[reindeer.name] = 0
    end
    for t in 1..tmax do
      distances = {}
      @athletes.each do |reindeer|
        dist = reindeer.dist_after_secs t
        distances[reindeer.name] = dist
        if dist >= max_dist
          max_dist = dist
          best_athlete = reindeer
          #infolog( "newmax t={t} dist=#{max_dist} by #{reindeer.to_s}" )
        end
      end
      @athletes.each do |reindeer|
        if distances[reindeer.name] == max_dist
          scores[reindeer.name] += 1
        end
      end
    end
    infolog("algo returns #{max_dist}")
    infolog("algo returns #{scores}")
    infolog("  score-winner #{scores.max_by{|k,v| v}}")
    return(max_dist)
  end
end # class DayXXSolver

#** "MAIN", including unit tests

require 'test/unit'
class Test01Examples < Test::Unit::TestCase
  def test_example_01
    return
  end

  def test_example_02
    t_race = 1000
    day14solver = Day14Solver.new
    day14solver.fn = "adventcode2015_test14.txt"
    day14solver.log_level = 2
    day14solver.infolog("day14solver instantiated")
    day14solver.algo_exec(t_race)
  end
end # class

class Test02Solution < Test::Unit::TestCase
  def test_solution_1
    t_race = 2503
    day14solver = Day14Solver.new
    day14solver.fn = "adventcode2015_in14.txt"
    day14solver.log_level = 2
    day14solver.infolog("day14solver instantiated")
    day14solver.algo_exec(t_race)
  end
end

puts "program ends."

__END__

Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.
Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.
