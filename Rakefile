require "rake/testtask"

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
