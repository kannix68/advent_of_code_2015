#!/usr/bin/ruby
##
# advent of code 2015. kannix68.
# Day 19: Medicine for Rudolph
# Part [B].
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

  def mol_regen_backwards(ins, reps)
    repso = reps.sort_by { |ary| ary[1].length * -1 } # long result in front!
    deblog "ordered=" + repso.inspect

    found = true
    oiters = 0
    iiters = 0
    tmps = ins.dup
    deblog "  input=#{tmps}"
    deblog "  input len=#{tmps.length}"
    while found do
      tracelog "oiters=#{oiters}, iiters=#{iiters}"
      oiters += 1
      found = false
      repso.each do |repary|
        iiters += 1
        if tmps =~ /#{repary[1]}$/
          tmps = tmps.sub(/(.*)#{repary[1]}$/, '\1') + repary[0]
          #tmpscheck = tmps.sub(/(.*)#{repary[1]}$/, '\1') + repary[0]
          #cont = true
          #reps.each do |checkary|
          #  if tmpscheck =~ /#{checkary[1]}$/ || tmpscheck == 'e'
          #    cont = true
          #  end
          #  break
          #end
          #if cont
          #  tmps = tmpscheck
          tracelog "  tmps=#{tmps}"
          deblog "replaced to len=#{tmps.length} from #{repary}"
          found = true
          break # reps
          #else
          #  puts "WARN NO continuation for replacement  #{repary}, #{tmpscheck[-10..tmpscheck.length-1]}"
          #end
        end
      end
      if tmps == 'e'
        found = true
        break
      end
      if found && oiters > 5
        break
      elsif !found
        infolog "ERROR nothing found at #{tmps}"
        oiters *= -1
      end
    end
    oiters
  end

  def mol_regen_all(ins, reps)
    tracelog "mol_regen_all"
    repso = reps.sort_by { |ary| ary[1].length * -1 } # long result in front!
    deblog "ordered=" + repso.inspect

    found = true
    oiters = 0
    iiters = 0
    tmps = ins.dup
    deblog "  input=#{tmps}<"
    deblog "  input len=#{tmps.length}"
    while found do
      tracelog "startloop tmps-len=#{tmps.length} tmps=#{tmps}<"
      deblog "startloop oiters=#{oiters}, iiters=#{iiters}, tmps-len=#{tmps.length}"
      oiters += 1
      found = false
      repso.each do |repary|
        iiters += 1
        if tmps =~ /#{repary[1]}/
          tracelog "  found in tmps=#{tmps}, len=#{tmps.length}"
          tmps = tmps.sub(/(.*)#{repary[1]}(.*?)$/, "\\1#{repary[0]}\\2")
          tracelog "  tmps=#{tmps}"
          deblog "replaced to len=#{tmps.length} from #{repary} tmps=#{tmps}<"
          found = true
          break # reps
        end
      end
      if tmps == "e"
        found = true
        break
      end
      if found && oiters > 1000
        break
      elsif !found
        infolog "ERROR nothing found at #{tmps}"
        oiters *= -1
      end
    end

    deblog "  tmps=#{tmps}"
    deblog "  len=#{tmps.length}"
    deblog "oiters=#{oiters}, iiters=#{iiters}"
    oiters
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
    return
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

  def test_example_03
    @log_level = 2
    infolog "test_example_03"
    reps = [
      ['e', 'H'],
      ['e', 'O'],
      ['H', 'HO'],
      ['H', 'OH'],
      ['O', 'HH'],
    ]

    ins = 'HOH'
    varis = mol_regen_all(ins, reps)
    infolog "result test regen backw iterations = #{varis}"
  end

  def test_example_04
    @log_level = 2
    infolog "test_example_04"
    reps = [
      ['e', 'H'],
      ['e', 'O'],
      ['H', 'HO'],
      ['H', 'OH'],
      ['O', 'HH'],
    ]

    ins = 'HOHOHO'
    varis = mol_regen_all(ins, reps)
    infolog "result test regen backw iterations = #{varis}"
  end

  #def test_solution_B
  def test_example_05
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
    varis = mol_regen_all(ins, reps)
    infolog "result test num combis = #{varis}"
  end
end # class

class Test02Solution < Test::Unit::TestCase
  def test_solution_1
  end
end

puts "program ends."

__END__
