require 'find'
require 'fileutils'
require 'tempfile'
require 'colorize'

class Byepry
  def self.go
    Find.find('.') do |path|
      next unless path =~ /.*\.rb$/
      file = File.open(path, 'r+')
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
        end
        tmp << l unless l.include? 'binding.pry'
      end

      # Close tmp
      tmp.close
      # Move temp file to origin if file changed
      FileUtils.mv(tmp.path, path) if changed_file
    end
  end
end
