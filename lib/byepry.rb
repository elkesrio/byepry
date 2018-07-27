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
      # Open a temporary file
      tmp = Tempfile.new('extract')
      puts file
      changed_file = remove_pry_from_file(file, tmp) unless @options

      tmp.close
      # Move temp file to origin if file changed
      FileUtils.mv(tmp.path, path) if changed_file
    end
  end

  def remove_pry_from_file(file, tmp)
    changed_file = false
    line_number = 0

    # Write good lines to temporary file
    open(file, 'r').each do |l|
      line_number += 1

      if condition_to_remove? l
        changed_file = true
        puts "Removed pry from File: #{file.path} Line: #{line_number}".green
      else
        tmp << l
      end
    end

    changed_file
  end

  def condition_to_remove?(line)
    # Remove all 'binding.pry'
    return line.include?('binding.pry') unless @options
    # Ignore commented lines
    return line.include?('binding.pry') && !l.starts_with?('#') if @options == '-i'
  end
end

Byepry.new(ARGV).go
