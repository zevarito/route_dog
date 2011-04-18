require "rake/testtask"

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "route_dog"
    gem.summary = %Q{Watch and Notify your not tested routes of a RoR Application}
    gem.description = %Q{Watch and Notify your not tested routes of a RoR Application, it also has a simple report about Routes defines, used and tested}
    gem.rubyforge_project = "routedog"
    gem.email = "zevarito@gmail.com"
    gem.homepage = "http://github.com/zevarito/route_dog"
    gem.authors = ["Alvaro Gil"]
    gem.add_dependency 'rack'
    gem.add_dependency 'rails', '>=2.3.8'
    gem.add_development_dependency "contest", "=0.1.2"
    gem.add_development_dependency "nokogiri", "=1.4.3.1"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

desc "Default: run tests"
task :default => [:clean, :test, :report]

Rake::TestTask.new do |t|
  t.libs << "lib" << "test"
  t.test_files = FileList["test/**/*_test.rb"]
end

task :clean do
  `cd test/mock_app && rake route_dog:clean`
end

task :report do
  `cd test/mock_app && rake route_dog:report`
end
