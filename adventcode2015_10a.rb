# ruby
##
# advent of code 2015. kannix68.
# Day 10: Elves Look, Elves Say
#
# about the algorithm:
#   single threaded brute force using ruby strings as data structures
#   and concatenation as op.
#

#-$:.unshift File.dirname(__FILE__)
#-require 'aocbase.rb'

#** Helpers class

class AocBase
  DEBLOG = 0;  # 0|1

  def tracelog(s)
    if (DEBLOG > 1) then
      s.chomp!
      STDERR.puts "T: #{s}"
    end
  end

  def deblog(s)
    if (DEBLOG > 0) then
      s.chomp!
      STDERR.puts "D: #{s}"
    end
  end

  def infolog(s)
    s.chomp!
    STDERR.puts "I: #{s}"
  end

  def readfile(infile)
    counter = 0
    data = ''
    firstline = ''
    # one _or_ multiline line input
    File.open(infile, "r") do |infile|
      while (line = infile.gets)
        counter = counter + 1
        if counter == 2
          firstline = data.chomp
        end
        data = data + line
        #puts "#{counter}: #{line}"
      end
    end
    if counter == 1
      data = data.sub(/(\x0D)?\x0A$/, '');
      deblog("data is len=#{data.length}, >#{data}<.");
    else
      deblog("data has=#{counter} lines, first is >#{firstline}<.");
    end
    return(data)
  end

  def readdata()
    deblog("basename=#{$0}");
    script = $0;
    infile = script.gsub(/^\.?\/(adventcode2015_)(.*?)[a-z]?\.rb$/, '\1in\2.txt');
    if script == infile
      abort("error parsing datafile name")
    end
    deblog("data filename=#{infile}");
    return( readfile(infile) )
  end
end # class AocBase

#** our algorithm

class Day10Solver <AocBase
  def algo_exec(ins)
    deblog("input = >#{ins}<.")
    outs = ''
    lastc = ''
    cct = 0
    for i in 0..(ins.length-1)
      c = ins[i]
      tracelog("iter ##{i} >#{c}<")
      if c == lastc
        tracelog("  char remains")
        cct = cct + 1
      else
        tracelog("  char changes")
        if lastc != '' # < omit inital char-change at pos 0
          outs = outs + "#{cct}#{lastc}"
        end
        cct = 1
        lastc = c
      end
      if i == ins.length-1
        tracelog("  write final char")
        outs = outs + "#{cct}#{c}"
      end
    end
    deblog("returns >#{outs}< from >#{ins}<")
    return(outs)
  end
end # class DayXXSolver

#** "MAIN", including unit tests

require 'test/unit'
class Test01Examples < Test::Unit::TestCase
  def test_example_1
    day10solver = Day10Solver.new
    day10solver.infolog("day10solver instantiated")
    s = day10solver.algo_exec('1')
    assert_equal( '11', s, "algorithm result 1->11" )
  end
  def test_example_2
    day10solver = Day10Solver.new
    ins = '11'; exps = '21'
    assert_equal( exps, day10solver.algo_exec(ins), "algorithm result #{ins}->#{exps}" )
  end
  def test_example_3
    day10solver = Day10Solver.new
    ins = '21'; exps = '1211'
    assert_equal( exps, day10solver.algo_exec(ins), "algorithm result #{ins}->#{exps}" )
  end
  def test_example_4
    day10solver = Day10Solver.new
    ins = '1211'; exps = '111221'
    assert_equal( exps, day10solver.algo_exec(ins), "algorithm result #{ins}->#{exps}" )
  end
  def test_example_5
    day10solver = Day10Solver.new
    ins = '111221'; exps = '312211'
    assert_equal( exps, day10solver.algo_exec(ins), "algorithm result #{ins}->#{exps}" )
  end
end # class

class Test02Solution < Test::Unit::TestCase
  def test_solution_1
    day10solver = Day10Solver.new
    ins = day10solver.readdata()
    assert( !ins.nil? && ins != '', "data file read" )
    for i in 1..40
      day10solver.infolog(
        "in #{i} (###{ins.length})= >#{ins[0..79]}#{if ins.length > 80 then '...' end}<."
      )
      ins = day10solver.algo_exec(ins)
    end
    day10solver.infolog(
      "result #{i} (###{ins.length})= >#{ins[0..79]}#{if ins.length > 80 then '...' end}<."
    )
    puts "RESULT (## #{ins.length}) >>"
    puts "#{ins}"
    puts "<< RESULT (## #{ins.length})"
  end
end

puts "program ends."

__END__

1 becomes 11 (1 copy of digit 1).
11 becomes 21 (2 copies of digit 1).
21 becomes 1211 (one 2 followed by one 1).
1211 becomes 111221 (one 1, one 2, and two 1s).
111221 becomes 312211 (three 1s, two 2s, and one 1).
