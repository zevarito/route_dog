files = ['README.md', 'LICENSE', 'Rakefile', 'route_dog.gemspec', '{test,lib}/**/*'].map {|f| Dir[f]}.flatten

Gem::Specification.new do |s|
  s.name = "route_dog"
  s.version = "2.5.1"
  s.author = "Alvaro Gil"
  s.date = "2011-04-18"
  s.description = "Watch and Notify your not tested routes of a RoR Application, it also has a simple report about Routes defines, used and tested"
  s.email = "zevarito@gmail.com"
  s.extra_rdoc_files = ["LICENSE", "README.md"]
  s.files = files
  s.homepage = "http://github.com/zevarito/route_dog"
  s.require_paths = ["lib"]
  s.rubyforge_project = "routedog"
  s.summary = "Watch and Notify your not tested routes of a RoR Application"
  s.add_runtime_dependency(%q<rack>, [">= 0"])
  s.add_runtime_dependency(%q<rails>, [">= 2.3.8"])
  s.add_development_dependency(%q<contest>, ["= 0.1.2"])
  s.add_development_dependency(%q<nokogiri>, ["= 1.4.3.1"])
end

