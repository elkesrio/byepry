require 'minitest/autorun'
require 'byepry'
require 'pry'

class ByepryTest < Minitest::Test
  def test_initialize_with_no_param_sets_options_to_empty_array
    assert_equal [], Byepry.new.options
  end

  def test_remove_pry_from_file_removes_pry_from_files_when_options_is_empty
    tmp = Tempfile.new('extract')

    file = File.open('test.txt', 'w+')
    file.puts('first line without pry')
    file.puts('binding.pry')
    file.puts('# binding.pry')
    file.close

    file = File.open('test.txt', 'r')

    changed_file = Byepry.new.remove_pry_from_file(file, tmp)

    FileUtils.mv(tmp.path, file.path) if changed_file

    assert_equal ['first line without pry'], File.readlines('test.txt')
  end
end
