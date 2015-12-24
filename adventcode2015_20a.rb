#!/usr/bin/ruby
##
# advent of code 2015. kannix68.
# Day 20: Infinite Elves and Infinite Houses
# Part [B].
#


$:.unshift File.dirname(__FILE__)
require 'aocbase.rb' # < helpers class

#** our algorithm


#** "MAIN", including unit tests

require 'test/unit'
class Test01Examples < Test::Unit::TestCase
  include LogBase

  def house_presents(house_num)
    deblog "house_presents( house_num=#{house_num} )"
    psum = 0
    (1..house_num).each do |elf_num|
      if house_num % elf_num == 0
        tracelog "house_num=#{house_num} elf_num=#{elf_num} mod-match!"
        psum += elf_num * 10
      end
    end
    deblog "psum=#{psum}"
    psum
  end


  def test_example_01
    @log_level = 2
    hn = 1
    expd = 10
    n = house_presents(hn)
    assert_equal( expd, n, "house #{hn}" )
    infolog "result house presents hn=#{hn} presents=#{n} expected #{expd}"

    hn = 2
    expd = 30
    n = house_presents(hn)
    assert_equal( expd, n, "house #{hn}" )
    infolog "result house presents hn=#{hn} presents=#{n} expected #{expd}"

    hn = 3
    expd = 40
    n = house_presents(hn)
    assert_equal( expd, n, "house #{hn}" )
    infolog "result house presents hn=#{hn} presents=#{n} expected #{expd}"

    hn = 4
    expd = 70
    n = house_presents(hn)
    assert_equal( expd, n, "house #{hn}" )
    infolog "result house presents hn=#{hn} presents=#{n} expected #{expd}"

    hn = 5
    expd = 60
    n = house_presents(hn)
    assert_equal( expd, n, "house #{hn}" )
    infolog "result house presents hn=#{hn} presents=#{n} expected #{expd}"

    hn = 6
    expd = 120
    n = house_presents(hn)
    assert_equal( expd, n, "house #{hn}" )
    infolog "result house presents hn=#{hn} presents=#{n} expected #{expd}"

    hn = 7
    expd = 80
    n = house_presents(hn)
    assert_equal( expd, n, "house #{hn}" )
    infolog "result house presents hn=#{hn} presents=#{n} expected #{expd}"

    hn = 8
    expd = 150
    n = house_presents(hn)
    assert_equal( expd, n, "house #{hn}" )
    infolog "result house presents hn=#{hn} presents=#{n} expected #{expd}"

    hn = 9
    expd = 130
    n = house_presents(hn)
    assert_equal( expd, n, "house #{hn}" )
    infolog "result house presents hn=#{hn} presents=#{n} expected #{expd}"
  end

  def test_example_02
  end

  def test_solution_A
    @log_level = 0
    minpres = 33100000  # 33_100_000
    infolog("start solution for min presents = #{minpres}")
    
    curpres = 0
    hn = 0
    maxpres = 0
    while curpres < minpres && hn < ((minpres+1)/10+1)
      if hn % 1_000 == 0
        STDERR.print "."
      end
      hn += 1
      curpres = house_presents(hn)
      if curpres > maxpres
        maxpres = curpres
        infolog "house_num=#{hn} new max presents # = #{maxpres}"
      end
    end
    infolog("housenum #{hn}; # presents = #{curpres}")
  end

end # class

class Test02Solution < Test::Unit::TestCase
  def test_solution_1
  end
end

puts "program ends."

__END__
