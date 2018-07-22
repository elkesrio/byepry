require 'find'
require 'fileutils'
require 'tempfile'
require 'colorize'

class Byepry
  def initialize(options = nil)
    @options = options
  end

  def go
    Find.find('.') do |path|
      next unless path =~ /.*\.(rb|erb)$/

      file = File.open(path, 'r+')

      remove_pry_from_file(file) unless @options
    end
  end

  def remove_pry_from_file(file)
    # Open a temporary file
    tmp = Tempfile.new('extract')

    changed_file = false
    line_number = 0

    # Write good lines to temporary file
    open(path, 'r').each do |l|
      line_number += 1

      if l.include? 'binding.pry'
        changed_file = true
        puts "Removed pry from File: #{path} Line: #{line_number}".green
      else
        tmp << l
      end
    end

    # Close tmp
    tmp.close
    # Move temp file to origin if file changed
    FileUtils.mv(tmp.path, path) if changed_file
  end
end
