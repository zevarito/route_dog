require "rake/testtask"

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
