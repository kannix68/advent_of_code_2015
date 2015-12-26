#!/bin/ruby
##
# Advent of code. kannix68 @ github
# Day 25: Let It Snow
# Part [A].
#

$:.unshift File.dirname(__FILE__)
require 'aocbase.rb' # < helpers class

include LogBase
@log_level = 1

##
# get diagonal num and element offset for given index
def get_diagdet_for_idx(idx)
  idxcount = 0
  diag = 0
  diagstart = 0
  while( idxcount < idx )
    diagstart = idxcount+1
    diag += 1
    idxcount += diag
  end
  diagdiff = idx - diagstart

  return [diag, diagdiff]
end

##
# get [row, col] position for given index.
def get_pos_for_idx(idx)
  idxcount = 0
  diag = 0
  
  diagstart = 0
  while( idxcount < idx )
    diagstart = idxcount+1
    diag += 1
    idxcount += diag
    #deblog("  diag #{diag} ends at # #{idxcount}; diagstart @idx #{diagstart}")
  end
  diagdiff = idx - diagstart
  #deblog("  idx #{idx} is on diag #{diag}; diagdiff=#{diagdiff}")
  
  irow = diag
  icol = 1
  ipos = [irow-diagdiff, icol+diagdiff]
  tracelog("  pos4idx returns #{ipos}")
  ipos
end

def get_diagnum_for_pos(prow, pcol)
end

##
# get index for given [row, col] position.
def get_index_for_pos(prow, pcol)
  idx = 0
  ct = 0
  maxidx = 1e10.to_i
  #deblog("idx4pos(row:#{prow}, col:#{pcol}) starts; maxidx=#{maxidx}")
  while idx < maxidx
    ct += 1
    idx += 1
    STDERR.print '.' if ct % 1000 == 0
    STDERR.puts ">#{idx}: #{get_pos_for_idx(idx)}" if ct % (1000*100) == 0
    aa = get_pos_for_idx(idx)
    #deblog("aa=#{aa} pos4idx tst #{idx}")
    if aa[0]==prow and aa[1]==pcol
      tracelog("idx4pos=#{idx} @ [#{prow}, #{pcol}]")
      return idx
    end
  end
  #deblog("idx4pos fail=#{idx} @ [#{prow}, #{pcol}]")
  raise "no pos4idx found"
end

def get_next_val(i)
  (i*252533) % 33554393
end

(1..7).each do |i|
  tst = get_pos_for_idx(i)
  deblog("  pos4idx(#{i}) = #{tst}")
end

(1..6).each do |icol|
  (1..6).each do |irow|
  tst = get_index_for_pos(irow, icol)
  deblog("tst idx4pos(row:#{irow}, col:#{icol}) = #{tst}")
  end
end

# Enter the code at row 2981, column 3075.
#!!!! run get_index once to get the index, it takes a while...
#qidx = get_index_for_pos(2981, 3075)
qidx = 18331560
infolog("query idx=#{qidx}");
#exit

# 18331560
infolog("query pos=#{get_pos_for_idx(qidx)}");

a1 = 20151125
fidx = qidx # < insert found index
infolog("va(1) = #{a1}")
va = a1
(2..fidx).each do |i|
  STDERR.print '.' if i % 100000 == 0
  va = get_next_val(va)
  #infolog("a#{i}=#{a[i]}")
  infolog("va(#{i}) = #{va}") if i < 6
end
infolog("RESULT va(#{fidx}) = #{va}")

exit
##############################################################################

a = []
a[0] = nil
a[1] = 20151125
infolog("a1=#{a[1]}")
(2..12).each do |i|
  a[i] = get_next_val(a[i-1])
  infolog("a#{i}=#{a[i]}")
end

irow = 2981
icol = 3075

exit
