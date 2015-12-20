#!/usr/bin/ruby
##
# advent of code 2015. kannix68.
# Day 19: Day 19: Medicine for Rudolph
# Part [A].
#


$:.unshift File.dirname(__FILE__)
require 'aocbase.rb' # < helpers class

#** our algorithm

#** "MAIN", including unit tests

require 'test/unit'
class Test01Examples < Test::Unit::TestCase
  include LogBase

  def mol_variations(ins, reps)
    maxidx = ins.length-1
    varis = []
    (0..maxidx).each do |sidx|
      subs = ins[sidx..maxidx]
      pres = ''
      if sidx > 0
        pres = ins[0..sidx-1]
      end
      tracelog "sidx=#{sidx} subs=#{subs}; pres=#{pres}"
      reps.each do |repary|
        if subs.start_with?(repary[0])
          tracelog "repl #{repary.inspect}"
          varis.push(pres + subs.sub(/^#{repary[0]}/, repary[1]))
          #tracelog "  new varis #{varis.inspect}"
        end
      end
    end

    creations = varis.length
    varis = varis.uniq
    tracelog "varis=#{varis.sort.inspect}"
    deblog "#varis=#{varis.length} of #creations=#{creations};"
    varis
  end


  def test_example_01
    @log_level = 2
    reps = [
      ['H', 'HO'],
      ['H', 'OH'],
      ['O', 'HH'],
    ]
    ins = 'HOH'
    varis = mol_variations(ins, reps)
    infolog "result test num combis = #{varis.length}"
  end

  def test_example_02
    @log_level = 2
    reps = [
      ['H', 'HO'],
      ['H', 'OH'],
      ['O', 'HH'],
    ]
    ins = 'HOHOHO'
    varis = mol_variations(ins, reps)
    infolog "result test num combis = #{varis.length}"
  end
  
  def test_solution_A
    @log_level = 2
    reps = [
      ['H', 'HO'],
      ['Al', 'ThF'],
      ['Al', 'ThRnFAr'],
      ['B', 'BCa'],
      ['B', 'TiB'],
      ['B', 'TiRnFAr'],
      ['Ca', 'CaCa'],
      ['Ca', 'PB'],
      ['Ca', 'PRnFAr'],
      ['Ca', 'SiRnFYFAr'],
      ['Ca', 'SiRnMgAr'],
      ['Ca', 'SiTh'],
      ['F', 'CaF'],
      ['F', 'PMg'],
      ['F', 'SiAl'],
      ['H', 'CRnAlAr'],
      ['H', 'CRnFYFYFAr'],
      ['H', 'CRnFYMgAr'],
      ['H', 'CRnMgYFAr'],
      ['H', 'HCa'],
      ['H', 'NRnFYFAr'],
      ['H', 'NRnMgAr'],
      ['H', 'NTh'],
      ['H', 'OB'],
      ['H', 'ORnFAr'],
      ['Mg', 'BF'],
      ['Mg', 'TiMg'],
      ['N', 'CRnFAr'],
      ['N', 'HSi'],
      ['O', 'CRnFYFAr'],
      ['O', 'CRnMgAr'],
      ['O', 'HP'],
      ['O', 'NRnFAr'],
      ['O', 'OTi'],
      ['P', 'CaP'],
      ['P', 'PTi'],
      ['P', 'SiRnFAr'],
      ['Si', 'CaSi'],
      ['Th', 'ThCa'],
      ['Ti', 'BP'],
      ['Ti', 'TiTi'],
      ['e', 'HF'],
      ['e', 'NAl'],
      ['e', 'OMg'],
    ]

    ins = "CRnSiRnCaPTiMgYCaPTiRnFArSiThFArCaSiThSiThPBCaCaSiRnSiRnTiTiMgArPBCaPMgYPTiRnFArFArCaSiRnBPMgArPRnCaPTiRnFArCaSiThCaCaFArPBCaCaPTiTiRnFArCaSiRnSiAlYSiThRnFArArCaSiRnBFArCaCaSiRnSiThCaCaCaFYCaPTiBCaSiThCaSiThPMgArSiRnCaPBFYCaCaFArCaCaCaCaSiThCaSiRnPRnFArPBSiThPRnFArSiRnMgArCaFYFArCaSiRnSiAlArTiTiTiTiTiTiTiRnPMgArPTiTiTiBSiRnSiAlArTiTiRnPMgArCaFYBPBPTiRnSiRnMgArSiThCaFArCaSiThFArPRnFArCaSiRnTiBSiThSiRnSiAlYCaFArPRnFArSiThCaFArCaCaSiThCaCaCaSiRnPRnCaFArFYPMgArCaPBCaPBSiRnFYPBCaFArCaSiAl"
    tracelog("reps=#{reps}")
    tracelog("ins=#{ins}")
    varis = mol_variations(ins, reps)
    infolog "result test num combis = #{varis.length}"
  end

end # class

class Test02Solution < Test::Unit::TestCase
  def test_solution_1
  end
end

puts "program ends."

__END__

Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.
Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.
