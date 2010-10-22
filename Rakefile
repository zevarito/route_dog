require "rake/testtask"

desc "Default: run tests"
task :default => :test

Rake::TestTask.new do |t|
  File.delete("test/mock_app/config/route_dog_routes.yml") if File.exists? "test/mock_app/config/route_dog_routes.yml"
  t.libs << "lib" << "test"
  t.test_files = FileList["test/**/*_test.rb"]
end
