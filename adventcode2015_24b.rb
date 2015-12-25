#!/bin/ruby
##
# Advent of code. kannix68 @ github
# Day 24: It Hangs in the Balance
# Part [A].
#

$:.unshift File.dirname(__FILE__)
require 'aocbase.rb' # < helpers class

include LogBase
@log_level = 2

ins_ar = [ 1, 2, 3, 7, 11, 13, 17, 19, 23, 31, 37, 41, 43, 47, 53, 59, 61, 67,
  71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113 ]
ins_sum = ins_ar.reduce(:+);
ins_partwt = ins_sum / 4.0

infolog("ins ary #elems=#{ins_ar.length}; sum=#{ins_sum}; part weigth=#{ins_partwt}")
#tracelog("  ary=#{ins_ar}")
ins_partwt = ins_sum / 4

pcount = 0 # <magic
##############################################################################

#** subs
@ovcount = 0;

def set_divide_even(tset, tnum, tpartsum, tminelems)
  tsetlen = tset.length
  deblog("set_divide_even set-len=#{tsetlen}, #-sets=#{tnum}, partial-sum=#{tpartsum}, min-#-elems=#{tminelems}")
  #deblog("  on set=#{tset}")
  if tnum == 1
    if tset.reduce(:+) == tpartsum && tsetlen >= tminelems
      return [].push tset
    else
      raise "  not wellformed: set-partsum=#{tset.reduce(:+)}; tsetlen=#{tsetlen}"
    end
  end
  tsetfound = false
  foundsets = []
  #tracelog("  set=#{tset}")
  max_num = tsetlen/tnum+1
  #deblog("  permutate levels #{tminelems} to #{max_num}")
  (tminelems..max_num).each do |lvl1|
    #deblog("  permutate(#{lvl1} set=#{tset})")
    tset.permutation(lvl1).each do |prm|
      @ovcount += 1
      STDERR.print '.' if @ovcount % 1000000 == 0
      if prm.reduce(:+) == tpartsum
        restset = tset.dup
        prm.each do |elem|
          restset.delete(elem)
        end
        deblog("  found valid part #{prm}; restset=#{restset}")
        foundsets.push(prm)
        if restset == []
          return prm
        end
        fset = set_divide_even(restset, tnum-1, tpartsum, lvl1)
        if fset != nil
          #tracelog("  break on found fset=#{fset} from #{restset}")
          fset.each do |ary|
            foundsets.push(ary)
          end
          tsetfound = true
          break
        else
          raise "nil found on set #{restset}"
        end
      end
    end
    if tsetfound
      break
    end
  end
  #deblog("fin set_divide_even set-len=#{tsetlen}, #-sets=#{tnum}, partial-sum=#{tpartsum}, min-#-elems=#{tminelems}")
  #deblog("  found sets=#{foundsets}")
  if tsetfound
    tracelog("set_divide returns set=#{foundsets}")
    return foundsets
  else
    raise "nothing found"
    #tracelog("set_divide returns nil")
    #return nil
  end
end

#** main

pfound = false
found_perms = []
allcount = 0

def set_find_min_psum(tset, tpartlen, tpartsum)
  fset = []
  tsetlen = tset.length
  acount = 0
  deblog("set_find_min_psum set-len=#{tsetlen}, part.len=#{tpartlen}, partial-sum=#{tpartsum}")
  tset.permutation(tpartlen).each do |prm|
    acount += 1
    STDERR.print '.' if acount % 1000000 == 0
    if prm.reduce(:+) == tpartsum
      STDERR.print 'o'
      fset.push prm
    end
  end
  deblog("set_find_min_psum found-sets#=#{fset.length}; after #{acount} tries")
  return fset
end

all1sets = set_find_min_psum(ins_ar, 4, ins_partwt)
all1sets = all1sets.map {|a| a.sort.reverse}
fs = all1sets.uniq.sort_by {|a| a.reduce(:*) }
infolog("fset-len=#{fs.length}")

fsquent = fs.map {|a| a.reduce(:*)}
infolog("fs = #{fs[0..10]}")
infolog("fsquent = #{fsquent[0..10]}")

#infolog("#{fs}")

allcount = 0
res = nil
fs.each do |cand|
  allcount += 1
  res = set_divide_even(ins_ar, 4, ins_partwt, 1)
  if res.length == 4
    infolog("found cand at # #{allcount}: cand=#{cand}; qent=#{cand.reduce(:*)}")
    break
  end
end

infolog("RESULT=res");
exit
