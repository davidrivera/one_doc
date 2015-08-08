Gem::Specification.new do |s|
  s.name        = 'one_doc'
  s.version     = '0.0.1'
  s.date        = '2015-07-18'
  s.summary     = "OneDoc"
  s.description = "A simple doc gem"
  s.authors     = ["David Rivera"]
  s.email       = 'david.r.rivera193@gmail.com'
  s.files       = ["lib/one_doc.rb"]
  s.homepage    =
    'http://rubygems.org/gems/one_doc'
  s.license       = 'MIT'

  s.add_dependency "nokogiri"
  s.add_dependency "github-linguist"
end
