begin
  require "launchy"
rescue LoadError => e
  puts "Install launchy gem to automatically open the report in your browser"
end

namespace :route_dog do
  desc "Clean Tested Routes File"
  task :clean => :environment do
    if RouteDog.delete_watched_routes_file
      puts "\nRoute Dog tested routes definition file deleted."
    end
  end

  desc "Create A Html Report Of The Routes Defined, Tested And Used"
  task :report => :environment do
    puts "\nCreate A Html Report Of The Routes Defined, Tested And Used\n"
    RouteDog::Report.generate
  end
end
