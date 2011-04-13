begin
  require "launchy"
rescue LoadError => e
  puts "Install launchy gem to automatically open the report in your browser"
end

namespace :route_dog do
  desc "Clean Tested Routes File"
  task :clean do
    File.delete("test/mock_app/config/route_dog_routes.yml") if File.exists? "test/mock_app/config/route_dog_routes.yml"
    puts "\nRoute Dog tested routes definition file deleted."
  end

  desc "Create A Html Report Of The Routes Defined, Tested And Used"
  task :report => :environment do
    puts "\nCreate A Html Report Of The Routes Defined, Tested And Used\n"
    @implemented_routes = []
    @tested_routes = []
    @defined_routes = Rails.application.routes.routes
    @defined_routes.reject! { |r| r.path =~ %r{/rails/info/properties} } # Skip the route if it's internal info route
    save_and_open_report_in_browser(
      ERB.new(File.open(File.join(File.dirname(__FILE__), "report.html.erb")).read).result(binding)
    )
  end
end

def save_and_open_report_in_browser(html_report)
  path = File.join(Rails.root, "tmp", Rails.application.class.to_s.gsub(":", "").concat("RoutesReport.html").underscore)
  File.open(path, "w+") {|file| file.puts(html_report) }
  defined?(Launchy) ? Launchy::Browser.run(path) : puts("The report was saved in: #{path}")
end

def implemented_route?(route)
  if find_or_instantiate_controller_for(route).respond_to?(route.requirements[:action])
    @implemented_routes << route
    true
  else
    false
  end
end

def tested_route?(route)
  requirements = route.requirements
  if RouteDog.route_tested?(requirements[:controller], requirements[:action], route.verb)
    @tested_routes << route
    true
  else
    false
  end
end

def find_or_instantiate_controller_for(route)
  requirements = route.requirements
  @instantiated_controllers ||= {}
  if @instantiated_controllers.has_key?(requirements[:controller])
    @instantiated_controllers[requirements[:controller]]
  else
    begin
      @instantiated_controllers[requirements[:controller]] = RouteDog.constantize_controller_str(requirements[:controller]).new
    rescue
      false
    end
  end
end
