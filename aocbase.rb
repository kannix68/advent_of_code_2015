# ruby
##
# advent of code 2015. kannix68.

#** Helpers class

# A ruby helper class for advent of code.
class AocBase
  @log_level # 0|1|2

  def initialize()
    #puts "aocbase:initialize() called"
    @log_level = 0
  end

  def log_level=(lvl)
    if lvl < 0 && lvl > 2
      raise "unsupported log_level #{lvl}"
    end
    @log_level = lvl
  end

  # Trace level logging.
  def tracelog(s)
    if @log_level > 1
      s.chomp!
      STDERR.puts "T: #{s}"
    end
  end

  # Debug level logging.
  def deblog(s)
    if @log_level > 0
      s.chomp!
      STDERR.puts "D: #{s}"
    end
  end

  # Info level logging.
  def infolog(s)
    s.chomp!
    STDERR.puts "I: #{s}"
  end

  # Read an input file given by name into a string.
  def readfile(infile)
    counter = 0
    data = ''
    firstline = ''
    # one _or_ multiline line input
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
      data = data.sub(/(\x0D)?\x0A$/, '');
      deblog("data is len=#{data.length}, >#{data}<.");
    else
      deblog("data has=#{counter} lines, first is >#{firstline}<.");
    end
    return(data)
  end

  # Read an input file that is implicitly found by filename pattern
  #  adventcode2015_inDD.txt.
  def readdata()
    deblog("basename=#{$0}");
    script = $0;
    infile = script.gsub(/^\.?\/?(adventcode2015_)(.*?)[a-z]?\.rb$/, '\1in\2.txt');
    if script == infile
      abort("error parsing datafile name")
    end
    deblog("data filename=#{infile}");
    return( readfile(infile) )
  end
end # class AocBase

