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
ins_partwt = ins_sum / 3.0

infolog("ins ary #elems=#{ins_ar.length}; sum=#{ins_sum}; part weigth=#{ins_partwt}")
ins_partwt = ins_sum / 3

tms = Time.now

pcount = 4 # <magic
##############################################################################


pfound = false
found_perms = []
allcount = 0
while(!pfound and pcount < ins_ar.length)
  pcount += 1
  deblog("start-permut lvl=#{pcount} @#{Time.now-tms} secs");

  ins_ar.permutation(pcount) do |prm|
    allcount += 1
    perm_sum = prm.reduce(:+)
    if perm_sum == ins_partwt
      found_perms.push prm
      pfound = true
    end
    STDERR.print '.' if allcount % 1000000 == 0 and @log_level > 0
  end
  infolog("level #{pcount}; tries=#{allcount}; found=#{pfound}; num found=#{found_perms.length}")
  if pfound
    #tracelog("  found_perms=#{found_perms}")
    break
  end
end

qent_min = -1
found_perm = nil
found_perms.each do |prm|
  qent = prm.reduce(:*)
  if qent < qent_min or qent_min < 0
    found_perm = prm
    qent_min = qent
  end
end
infolog("found best perm: #{found_perm}; level=#{pcount} partwt=#{ins_partwt}; qent=#{qent_min} @#{Time.now-tms} secs")

rest_ar = ins_ar.dup
found_perm.each do |elem|
  rest_ar.delete(elem)
end
infolog("rest-array=#{rest_ar}")

rfound = false
rcount = pcount - 1
rest_perm = nil
leave_perm = nil
all_count = 0
while(!rfound and rcount < (rest_ar.length/2+1))
  rcount += 1
  infolog("start rest-level #{rcount} @#{Time.now-tms} secs")
  rest_ar.permutation(rcount) do |prm|
    allcount += 1
    perm_sum = prm.reduce(:+)
    if perm_sum == ins_partwt
      leave_ar = rest_ar.dup
      prm.each do |elem|
        leave_ar.delete(elem)
      end
      leave_sum = leave_ar.reduce(:+)
      deblog("rst-ary=#{prm} leave-ary=#{leave_ar}; arsum=#{leave_sum}")
      if leave_sum == ins_partwt
        rfound = true
        rest_perm = prm
        leave_perm = leave_ar
        break
      end
    end
    if rfound
      break
    end
    STDERR.print '.' if allcount % 1000000 == 0 and @log_level > 0
  end
end
if not rfound
  infolog("coud not part the rest #{rest-ary} into two even parts")
end
infolog("inner pack=#{found_perm}; @#{Time.now-tms} secs")
infolog("rest-pack 1=#{rest_perm};")
infolog("leave-pack 2 =#{leave_perm}")
