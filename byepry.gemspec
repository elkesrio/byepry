Gem::Specification.new do |s|
  s.name        = 'byepry'
  s.version     = '0.0.4'
  s.date        = '2018-05-11'
  s.summary     = "ByePry!"
  s.description = "A simple gem that removes the 'binding.pry' lines"
  s.authors     = ["Othmane EL KESRI"]
  s.email       = 'elkesri.othmane@gmail.com'
  s.files       = ["lib/byepry.rb"]
  s.executables << 'byepry'
  s.homepage    =
    'http://rubygems.org/gems/byepry'
  s.license       = 'MIT'

  s.add_dependency 'colorize', '~> 0.8.1'
end
