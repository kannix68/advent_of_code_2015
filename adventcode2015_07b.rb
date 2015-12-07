# ruby
##
# advent of code 2015. kannix68 (@github).
# Day 7: Some Assembly Required
# Part [B].
#
# About the solution: Brute force iterative replacements.
#   A grammar and parser solution would be better !?

DEBLOG = 0;  # 0|1

#** helpers
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
    infolog("data is len=#{data.length}, >#{data[0..80]}<.");
  else
    infolog("data has=#{counter} lines, first is >#{firstline[0..80]}<.");
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
    tracelog(" op=#{s} undefined")
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
      deblog("#{k} <= #{o1}")
      assigned = 1
    else
      tracelog("#{k} <= #{op1}");
    end
  elsif ( op =~ /^(\w+) AND (\w+) -> (\w+)$/ )
    op1, op2, k = $1, $2, $3
    return(0) if !$ops[k].nil?  # key already known
    o1 = op_from_rx(op1)
    o2 = op_from_rx(op2)
    if !o1.nil? && !o2.nil?
      $ops[k] = o1 & o2
      deblog("#{k} <= #{op1} AND #{op2}; k = #{$ops[k]}; o1=#{o1}, o2=#{o2}");
      assigned = 1
    else
      tracelog("#{k} <= #{op1} AND #{op2}");
    end
  elsif ( op =~ /^(\w+) OR (\w+) -> (\w+)$/ )
    op1, op2, k = $1, $2, $3
    return(0) if !$ops[k].nil?  # key already known
    o1 = op_from_rx(op1)
    o2 = op_from_rx(op2)
    if !o1.nil? && !o2.nil?
      $ops[k] = o1 | o2
      deblog("#{k} <= #{op1} OR #{op2}; k = #{$ops[k]}; o1=#{o1}, o2=#{o2}");
      assigned = 1
    else
      tracelog("#{k} <= #{op1} OR #{op2}");
    end
  elsif ( op =~ /^NOT (\w+) -> (\w+)$/ )
    op1, k = $1, $2
    return(0) if !$ops[k].nil?  # key already known
    o1 = op_from_rx(op1)
    if !o1.nil?
      $ops[k] = (~o1) & 65535
      deblog("#{k} <= NOT #{op1}; k = #{$ops[k]}; o1=#{o1}");
      assigned = 1
    else
      tracelog("#{k} <= NOT #{op1}; o1=#{o1}");
    end
  elsif ( op =~ /^(\w+) LSHIFT (\d+) -> (\w+)$/ )
    op1, op2, k = $1, $2, $3
    return(0) if !$ops[k].nil?  # key already known
    o1 = op_from_rx(op1)
    o2 = op_from_rx(op2)
    if !o1.nil? && !o2.nil?
      $ops[k] = (o1 << o2) & 65535
      deblog("#{k} <= #{op1} LSHIFT #{op2}; k = #{$ops[k]}; o1=#{o1}, o2=#{o2}");
      assigned = 1
    else
      tracelog("#{k} <= #{op1} LSHIFT #{op2}");
    end
  elsif ( op =~ /^(\w+) RSHIFT (\d+) -> (\w+)$/ )
    op1, op2, k = $1, $2, $3
    return(0) if !$ops[k].nil?  # key already known
    o1 = op_from_rx(op1)
    o2 = op_from_rx(op2)
    if !o1.nil? && !o2.nil?
      $ops[k] = o1 >> o2
      deblog("#{k} <= #{op1} RSHIFT #{op2}; k = #{$ops[k]}; o1=#{o1}, o2=#{o2}");
      assigned = 1
    else
      tracelog("#{k} <= #{op1} RSHIFT #{op2}");
    end
  else
    abort("parse error on #{op}");
  end
  return assigned
end


#** "MAIN"

def algo_exec_lines(lines)
  $ops = {}

  assigs=1
  iters= 0
  while( assigs > 0 && iters < lines.length) do
    iters = iters+1
    #infolog("iter: #{iters}")
    STDERR.print('.')
    assigs = 0
    lines.each { |opline|
      next if opline.nil?
      #next if not defined(opline)
      #deblog(">>#{opline}."); 
      res = algo_operate(opline)
      if res > 0
        deblog("ASSIGNED #{opline}")
        assigs = assigs + 1
      end
    }
    deblog("assignments=#{assigs}")
    #puts $ops.inspect
    STDOUT.flush
    STDERR.flush
  end

  STDERR.puts('')
  infolog("ended iterations=#{iters}")
  infolog("result a=#{$ops['a']}")
  return($ops['a'])
end

data = readdata()
lines = data.split(/(\x0D)?\x0A/)
a_value = algo_exec_lines(lines)
abort("bad a value") if a_value.nil?

lines2 = []
lines.each { |opline|
  if opline =~ /-> b$/
    opline2 = "#{a_value} -> b"
    infolog("changed #{opline} to #{opline2}")
    lines2.push(opline2)
  else
    lines2.push(opline)
  end
}
a_value = algo_exec_lines(lines2)
abort("bad a value") if a_value.nil?
