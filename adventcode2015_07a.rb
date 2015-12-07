#!/usr/bin/ruby
##
# advent of code 2015. kannix68 (@github).
# Day 7: Some Assembly Required.
#
# About the solution: Brute force iterative replacements.
#   A grammar and parser solution would be better !?

DEBLOG = 0;  # 0|1
TESTEXEC = 0;

#** helpers
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

def readdata()
  deblog("basename=#{$0}");
  script = $0;
  infile = script.gsub(/^(adventcode2015_)(.*?)[a-z]?\.rb$/, '\1in\2.txt');
  if script == infile
    abort("error parsing datafile name")
  end
  deblog("data filename=#{infile}");

  counter = 0
  data = ''
  firstline = ''
  # one line input
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
    deblog("data is len=#{data.length}, >#{data}<.");
  else
    deblog("data has=#{counter} lines, first is >#{firstline}<.");
  end
  return(data)
end

#** our algorithm
$ops = {}

def op_from_rx(s)
  res = nil
  if s =~ /^\d+$/
    res = s.to_i
  elsif !$ops[s].nil?
    res = $ops[s]
  else
    deblog(" op=#{s} undefined")
  end
  return(res)
end

def algo_operate(op)
  assigned = 0
  if ( op =~ /^(\w+) -> (\w+)$/ )
    # "123 -> x"; wired value
    op1, k = $1, $2
    return(0) if !$ops[k].nil?  # key already known
    o1 = op_from_rx(op1)
    if !o1.nil?
      $ops[k] = o1
      infolog("#{k} <= #{o1}")
      assigned = 1
    else
      deblog("#{k} <= #{op1}");
    end
  elsif ( op =~ /^(\w+) AND (\w+) -> (\w+)$/ )
    op1, op2, k = $1, $2, $3
    return(0) if !$ops[k].nil?  # key already known
    o1 = op_from_rx(op1)
    o2 = op_from_rx(op2)
    if !o1.nil? && !o2.nil?
      $ops[k] = o1 & o2
      infolog("#{k} <= #{op1} AND #{op2}; k = #{$ops[k]}; o1=#{o1}, o2=#{o2}");
      assigned = 1
    else
      deblog("#{k} <= #{op1} AND #{op2}");
    end
  elsif ( op =~ /^(\w+) OR (\w+) -> (\w+)$/ )
    op1, op2, k = $1, $2, $3
    return(0) if !$ops[k].nil?  # key already known
    o1 = op_from_rx(op1)
    o2 = op_from_rx(op2)
    if !o1.nil? && !o2.nil?
      $ops[k] = o1 | o2
      infolog("#{k} <= #{op1} OR #{op2}; k = #{$ops[k]}; o1=#{o1}, o2=#{o2}");
      assigned = 1
    else
      deblog("#{k} <= #{op1} OR #{op2}");
    end
  elsif ( op =~ /^NOT (\w+) -> (\w+)$/ )
    op1, k = $1, $2
    return(0) if !$ops[k].nil?  # key already known
    o1 = op_from_rx(op1)
    if !o1.nil?
      $ops[k] = (~o1) & 65535
      infolog("#{k} <= NOT #{op1}; k = #{$ops[k]}; o1=#{o1}");
      assigned = 1
    else
      deblog("#{k} <= NOT #{op1}; o1=#{o1}");
    end
  elsif ( op =~ /^(\w+) LSHIFT (\d+) -> (\w+)$/ )
    op1, op2, k = $1, $2, $3
    return(0) if !$ops[k].nil?  # key already known
    o1 = op_from_rx(op1)
    o2 = op_from_rx(op2)
    if !o1.nil? && !o2.nil?
      $ops[k] = (o1 << o2) & 65535
      infolog("#{k} <= #{op1} LSHIFT #{op2}; k = #{$ops[k]}; o1=#{o1}, o2=#{o2}");
      assigned = 1
    else
      deblog("#{k} <= #{op1} LSHIFT #{op2}");
    end
  elsif ( op =~ /^(\w+) RSHIFT (\d+) -> (\w+)$/ )
    op1, op2, k = $1, $2, $3
    return(0) if !$ops[k].nil?  # key already known
    o1 = op_from_rx(op1)
    o2 = op_from_rx(op2)
    if !o1.nil? && !o2.nil?
      $ops[k] = o1 >> o2
      infolog("#{k} <= #{op1} RSHIFT #{op2}; k = #{$ops[k]}; o1=#{o1}, o2=#{o2}");
      assigned = 1
    else
      deblog("#{k} <= #{op1} RSHIFT #{op2}");
    end
  else
    abort("parse error on #{op}");
  end
  return(assigned)
end


#** "MAIN"
require 'test/unit'
class Test0Basics < Test::Unit::TestCase
  def test_lshift_0
    assert_equal( 0, 0 << 1, "lshift 0" )
  end
  def test_lshift_1
    assert_equal( 2, 1 << 1, "lshift 1" )
  end
  def test_lshift_2
    assert_equal( 4, 1 << 2, "lshift 2" )
  end
end

#$in = (32768 << 1) & 65535;
#$expected = 0;
#ok($in == $expected, "test lshift overflow: $in = $expected.");

$ops = {}

def init_test()
  $ops = {}

testin = <<EOS;
123 -> x
456 -> y
x AND y -> d
x OR y -> e
x LSHIFT 2 -> f
y RSHIFT 2 -> g
NOT x -> h
NOT y -> i
EOS

  #deblog(testin)
  lines = testin.split(/(\x0D)?\x0A/)
  lines.each { |opline|
    #next if not defined(opline)
    #deblog(">#{opline}.");
    algo_operate(opline);
  }
  #puts $ops.inspect
end

class Test1ThisDay < Test::Unit::TestCase
  def setup
    init_test
  end
  def test_system_1
    ink='d'; expected = 72;
    assert_equal( expected, $ops[ink] )
  end
  def test_system_2
    ink='e'; expected = 507;
    assert_equal( expected, $ops[ink] )
  end
  def test_system_3
    ink='f'; expected = 492;
    assert_equal( expected, $ops[ink] )
  end
  def test_system_4
    ink='g'; expected = 114;
    assert_equal( expected, $ops[ink] )
  end
  def test_system_5
    ink='h'; expected = 65412;
    assert_equal( expected, $ops[ink] )
  end
  def test_system_6
    ink='i'; expected = 65079;
    assert_equal( expected, $ops[ink] )
  end
  def test_system_7
    ink='x'; expected = 123;
    assert_equal( expected, $ops[ink] )
  end
  def test_system_8
    ink='y'; expected = 456;
    assert_equal( expected, $ops[ink] )
  end
end

STDOUT.flush
STDERR.flush

def algo_exec
  $ops = {}
  data = readdata()
  lines = data.split(/(\x0D)?\x0A/)

  assigs=1
  iters= 0
  while( assigs > 0 && iters < lines.length) do
    iters = iters+1
    infolog("iter: #{iters}")
    assigs = 0
    lines.each { |opline|
      next if opline.nil?
      #deblog(">>#{opline}."); 
      res = algo_operate(opline)
      if res > 0
        infolog("ASSIGNED #{opline}")
        assigs = assigs + 1
      end
    }
    infolog("assignments=#{assigs}")
    puts $ops.inspect
    STDOUT.flush
    STDERR.flush
  end

  infolog("ended iterations=#{iters}")
  infolog("result a=#{$ops['a']}")
  return($ops['a'])
end

class Test2Final < Test::Unit::TestCase
  def setup
    $ops = {}
  end
  def test_final
   assert( !algo_exec().nil? )
  end
end
