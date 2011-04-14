begin
  require "launchy"
rescue LoadError => e
  puts "Install launchy gem to automatically open the report in your browser"
end

namespace :route_dog do
  desc "Clean Tested Routes File"
  task :clean do
    File.delete("test/mock_app/tmp/route_dog_routes.yml") if File.exists? "test/mock_app/tmp/route_dog_routes.yml"
    puts "\nRoute Dog tested routes definition file deleted."
  end

  desc "Create A Html Report Of The Routes Defined, Tested And Used"
  task :report => :environment do
    puts "\nCreate A Html Report Of The Routes Defined, Tested And Used\n"
    RouteDog::Report.generate
  end
end
