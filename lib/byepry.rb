require 'find'
require 'fileutils'
require 'tempfile'
require 'colorize'

class Byepry
  def initialize(options = [])
    @options = options
  end

  def go
    Find.find('.') do |path|
      next unless path =~ /.*\.(rb|erb)$/

      file = File.open(path, 'r+')
      # Open a temporary file
      tmp = Tempfile.new('extract')
      changed_file = remove_pry_from_file(file, tmp)

      tmp.close
      # Move temp file to origin if file changed
      FileUtils.mv(tmp.path, path) if changed_file
    end
  end

  def remove_pry_from_file(file, tmp)
    changed_file = false
    line_number = 0

    # Write good lines to temporary file
    file.each do |line|
      line_number += 1

      idx = remove_line_part(line)
      if idx
        changed_file = true
        puts "Removed pry from File: #{file.path} Line: #{line_number} col: #{idx}".green
        tmp << line[0...idx - 1] + "\n"
      elsif condition_to_remove? line
        changed_file = true
        puts "Removed pry from File: #{file.path} Line: #{line_number}".green
      else
        tmp << line
      end
    end

    changed_file
  end

  def condition_to_remove?(line)
    # Remove all 'binding.pry'
    return line.include?('binding.pry') if @options.empty?
    # Ignore commented lines
    return line.include?('binding.pry') && !line.strip.start_with?('#') if @options[0] == '-i'
  end

  def remove_line_part(line)
    return line.index('rescue binding.pry')
  end
end
