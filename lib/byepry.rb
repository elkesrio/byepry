require 'find'
require 'fileutils'
require 'tempfile'
require 'colorize'

# Main class
class Byepry
  def initialize(options = [])
    @options = options
  end

  def go(directoy_path)
    Find.find(directoy_path) do |path|
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

    # Write valid lines to temporary file
    file.each_with_index do |line, line_number|
      if condition_to_remove? line
        changed_file = true

        puts "Removed pry from File: #{file.path} Line: #{line_number}".green
      else
        tmp << line
      end
    end

    changed_file
  end

  def condition_to_remove?(line)
    if @options.empty?
      # Remove all 'binding.pry'
      line.include?('binding.pry')
    elsif @options[0] == '-i'
      # Ignore commented lines
      line.include?('binding.pry') && !line.strip.start_with?('#')
    end
  end
end
