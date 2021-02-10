#!/usr/bin/env ruby

require 'optparse'

class Enumerate_Tool
  def enumerate(options)
    i = options.fetch(:startnum)
    path = options.fetch(:path) 
    if path[/[\w0-9]*\z/] then
      path = path + '/'
    end
    
    options.fetch(:filepattern)[/([\w]+)\*\.([\w]+)\z/]
    
    if options.fetch(:new) == '' then
        prefix = $1
    else
        prefix = options.fetch(:new)
    end
    
    suffix = $2
    newfile = "#{prefix}%0#{options.fetch(:digits)}d.#{suffix}"

    begin
      Dir.children(path).sort.each do |file|
        if File.fnmatch(options.fetch(:filepattern), file) then
          File.rename(path + file, path + newfile %[i])
          puts file + " to " + newfile %[i]
          i = i + 1
        end
      end
    rescue => ex
      puts ex.message
    end
  end

  def validate(options)
    options
  end
end

class Options
  def parse(argv)
    options = {}

    optparse = OptionParser.new do |opts|
      opts.banner = 'Usage: rename_tool.rb [Options] directory'

      options[:digits] = 1
    	opts.on( '-d', '--digits DIGITS', 'Minimum digits for enumeration') do |digits|
    	  options[:digits] = digits
    	end

      options[:startnum] = 0
      opts.on( '-s', '--start NUMBER', 'Number to start numerating') do |number|
    	  options[:startnum] = number
      end

      options[:filepattern] = "*.*"
      opts.on( '-p', '--pattern PATTERN', 'Pattern files must match') do |pattern|
          options[:filepattern] = pattern
      end
        
      options[:new] = ''
      opts.on( '-n', '--new-file NAME', 'Name files should be renamed to') do |name|
    	  options[:new] = name
      end

      opts.on( '-h', '--help', 'Display this help') do
        puts opts.banner
      end
    end

    optparse.parse!(argv)
    options[:path] = argv[0]
    options
  end
end


opts = Options.new
options = opts.parse( ARGV )
puts options
unless options.fetch(:path) == nil  then
    tool = Enumerate_Tool.new
    tool.enumerate( options )
end
