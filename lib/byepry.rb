require 'find'
require 'fileutils'
require 'tempfile'
require 'colorize'
# require 'rubygems/command_manager'

class Byepry
  def execute
    Find.find(ARGV.first) do |path|
      if path =~ /.*\.rb$/
        file = File.open(path, 'r+')

        # Open temporary file
        tmp = Tempfile.new("extract")

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

        # Close tmp, or troubles ahead
        tmp.close

        # Move temp file to origin
        if changed_file
          FileUtils.mv(tmp.path, path)
        end
      end
    end
  end
end
