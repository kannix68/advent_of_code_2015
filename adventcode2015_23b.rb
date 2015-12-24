#!/bin/ruby
##
# Advent of code. kannix68 @ github
# Day 23: Opening the Turing Lock
# Part [A]
#

@log_level = 1
def tracelog(s)
  STDERR.puts("D: #{s}") unless @log_level < 2
end
def deblog(s)
  STDERR.puts("D: #{s}") unless @log_level < 1
end
def infolog(s)
  STDERR.puts("I: #{s}")
end

teststr = <<EOS
inc a
jio a, +2
tpl a
inc a
EOS

def compute(lines)
  regs = {'a'=>1, 'b'=>0}
  maxct = lines.length - 1
  linect = 0

  instrct = 0
  while linect <= maxct && instrct < 100000
    instrct += 1
    cur_linect = linect
    line = lines[linect]
    if match = line.match(/^(\w+) (a|b)?(?:(?:, )?([+\-]\d+))?$/)
      instr, reg, offs = match.captures
      tracelog("instruction=#{instr} on #{match.captures[1..2]}")
      case instr
      when "hlf"
        regs[reg] /= 2
        linect +=1
      when "tpl"
        regs[reg] *= 3
        linect +=1
      when "inc"
        regs[reg] += 1
        linect +=1
      when "jmp"
        linect += offs.to_i
      when "jie"
        if regs[reg] % 2 == 0
          linect += offs.to_i
        else
          linect += 1
        end
      when "jio"
        if regs[reg] == 1
          linect += offs.to_i
        else
          linect += 1
        end
      else
        raise "unknown instruction #{match.captures}"
      end # case
    else
      raise "unparseable line #{line}"
    end
    deblog "#{instrct}: instr #{instr} @#{cur_linect} done, new #{linect}; regs=#{regs}; cmd=#{match.captures.select{|v| !v.nil?}}"
  end
  deblog("program complete after #{instrct} instructions")
  regs
end

#** MAIN
lines = []
teststr.each_line do |s|
  line = s.chomp
  lines.push(line)
end

infolog("testing...")
res = compute(lines)
infolog("result=#{res}")

lines = []
File.readlines("adventcode2015_in23.txt").each do |line|
  lines.push(line)
end

infolog("computing...")
res = compute(lines)
infolog("result=#{res}")
