#!/bin/ruby
##
# Advent of code. kannix68 @ github
# Day 16: Aunt Sue
#

@log_level = 1
@feedback_every = 1000*100 # 1000
tsum = 100

def infolog(s)
  STDERR.puts("I: #{s}")
end
def deblog(s)
  if @log_level >= 1
    STDERR.puts("D: #{s}")
  end
end
def tracelog(s)
  if @log_level >= 2
    STDERR.puts("D: #{s}")
  end
end


crits = {
  :children => 3, :cats => 7, :samoyeds => 2, :pomeranians => 3, :akitas => 0,
  :vizslas => 0, :goldfish => 5, :trees => 3, :cars => 2, :perfumes => 1
}

aunts = []
File.readlines('adventcode2015_in16.txt').each do |line|
  if match = line.match(/^Sue (\d+): (\w+): (\d+), (\w+): (\d+), (\w+): (\d+)$/i)
    idx, k1, v1, k2, v2, k3, v3 = match.captures
    idx = idx.to_i
    k1, v1 = k1.to_sym, v1.to_i
    k2, v2 = k2.to_sym, v2.to_i
    k3, v3 = k3.to_sym, v3.to_i
    props = {k1 => v1, k2 => v2, k3 => v3, :idx => idx}
    deblog("aunt props=#{props}")
    aunts.push(props)
  else
    raise "unparseable line #{line}"
  end
end

aunts.each do |aunt|
  isgood = true
  aunt.each do |k, v|
    next if k == :idx
    if !crits[k].nil?
      if (k == :cats || k == :trees)
        if !(v > crits[k])
          isgood = false
        end
      elsif (k == :pomeranians || k == :goldfish)
        if !(v < crits[k])
          isgood = false
        end
      elsif !(v == crits[k])
        isgood = false
      end
    end
  end
  if isgood
    infolog("aunt is good := #{aunt}")
  end
end

__END__
