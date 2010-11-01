require "launchy"

namespace :route_dog do
  desc "Clean Tested Routes File"
  task :clean do
    File.delete("test/mock_app/config/route_dog_routes.yml") if File.exists? "test/mock_app/config/route_dog_routes.yml"
  end

  desc "Create A Html Report Of The Routes Defined, Tested And Used"
  task :report => :environment do
    routes = Rails.application.routes.routes
    routes.reject! { |r| r.path =~ %r{/rails/info/properties} } # Skip the route if it's internal info route
    save_and_open_report_in_browser(ERB.new(report_template(routes, {})).result(binding))
  end
end

def save_and_open_report_in_browser(html_report)
  path = Rails.application.class.to_s.gsub(":", "").concat("RoutesReport.html").underscore
  File.open(path, "w+") {|file| file.puts(html_report) }
  Launchy::Browser.run(path)
end

def report_template(routes, tested_routes)
  <<-EOT
    <html>
      <head>
        <style type="text/css">
        </style>
      </head>
      <body>
        <table>
        <tr><th>Method</th><th>Path</th><th>Implemented</th><th>Tested</th></tr>
        <% routes.each do |route| %>
          <tr>
            <td><%= route.verb %></td>
            <td><%= route.path %></td>
            <td><%= implemented_route?(route) ? "YES" : "NO" %></td>
            <td><%= tested_route?(route) ? "YES" : "NO" %></td>
        <% end %>
        </table>
      </body>
    </html>
  EOT
end

def implemented_route?(route)
  find_or_instantiate_controller_for(route).respond_to?(route.requirements[:action])
end

def tested_route?(route)
  require 'ruby-debug'
  debugger
  RouteDog.load_watched_routes
end

def find_or_instantiate_controller_for(route)
  requirements = route.requirements
  @instantiated_controllers ||= {}
  if @instantiated_controllers.has_key?(requirements[:controller])
    @instantiated_controllers[requirements[:controller]]
  else
    @instantiated_controllers[requirements[:controller]] = eval("#{requirements[:controller].capitalize}Controller.new")
  end
end
