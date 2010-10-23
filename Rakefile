require "rake/testtask"

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "route_dog"
    gem.summary = %Q{Watch and Notify your not tested routes of a RoR Application}
    gem.description = %Q{Watch and Notify your not tested routes of a RoR Application}
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
task :default => :test

namespace :route_dog do
  desc "Clean Tested Routes File"
  task :clean do
    File.delete("test/mock_app/config/route_dog_routes.yml") if File.exists? "test/mock_app/config/route_dog_routes.yml"
  end
end

Rake::TestTask.new do |t|
  Rake::Task["route_dog:clean"].invoke
  t.libs << "lib" << "test"
  t.test_files = FileList["test/**/*_test.rb"]
end
