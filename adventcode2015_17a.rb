#!/bin/ruby
##
# Advent of code. kannix68 @ github
# Day 17: No Such Thing as Too Much
# Parts [A] and [B].
#

@log_level = 0

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

def combine_to_sum(cset, tsum)
  rcombis = []
  ccombis = 0
  (1..cset.length).each do |nentities|
    cset.combination(nentities) do |lcombi|
      ccombis += 1
      if tsum == lcombi.reduce(:+)  # compare set sum
        deblog "valid combination found, n_entities=#{nentities}, #{lcombi}"
        rcombis.push(lcombi)
      end
    end
  end
  deblog("#{rcombis.length} valid combinations found, #{ccombis} calculated.")
  rcombis
end

def combine_minent_to_sum(cset, tsum)
  ccombis = 0
  rcombis = []
  (1..cset.length).each do |nentities|
    cset.combination(nentities) do |lcombi|
      ccombis += 1
      if tsum == lcombi.reduce(:+)  # compare set sum
        deblog "min-entities valid combination found, n_entities=#{nentities}, #{lcombi}"
        rcombis.push(lcombi)
      end
    end
    if rcombis.length > 0
      break  # break after minimum set-length found
    end
  end
  deblog(
    "#{rcombis.length} min-entities valid combinations found, " +
      "n_entities=#{rcombis[0].length}, #{ccombis} calculated."
  )
  rcombis
end

cset = [20, 15, 10, 5, 5]
tsum = 25
res = combine_to_sum(cset, tsum)
infolog("test combine result ##{res.length}; result=#{res}")
res = combine_minent_to_sum(cset, tsum)
infolog("min-ent test combine result #ents=#{res[0].length} ## #{res.length}; result=#{res}")

cset = [43, 3, 4, 10, 21, 44, 4, 6, 47, 41, 34, 17, 17, 44, 36, 31, 46, 9, 27, 38]
tsum = 150
res = combine_to_sum(cset, tsum)
infolog("challenge combine result ##{res.length}") #; result=#{res}")
res = combine_minent_to_sum(cset, tsum)
infolog("min-ent challenge combine result #ents=#{res[0].length} ## #{res.length}; result=#{res}")
