require "launchy"

namespace :route_dog do
  desc "Clean Tested Routes File"
  task :clean do
    File.delete("test/mock_app/config/route_dog_routes.yml") if File.exists? "test/mock_app/config/route_dog_routes.yml"
  end

  desc "Create A Html Report Of The Routes Defined, Tested And Used"
  task :report => :environment do
    @implemented_routes = []
    @tested_routes = []
    @defined_routes = Rails.application.routes.routes
    @defined_routes.reject! { |r| r.path =~ %r{/rails/info/properties} } # Skip the route if it's internal info route
    save_and_open_report_in_browser(ERB.new(report_template).result(binding))
  end
end

def save_and_open_report_in_browser(html_report)
  path = File.join(Rails.root, "tmp", Rails.application.class.to_s.gsub(":", "").concat("RoutesReport.html").underscore)
  File.open(path, "w+") {|file| file.puts(html_report) }
  Launchy::Browser.run(path)
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
    @instantiated_controllers[requirements[:controller]] = eval("#{requirements[:controller].capitalize}Controller.new")
  end
end

def report_template
  <<-EOT
    <html>
      <head>
        <style type="text/css">
        </style>
      </head>
      <body>
        <h1>Route Dog - <%= Rails.application.class %> - Routes Report</h1>
        <table>
        <tr><th>Method</th><th>Path</th><th>Action</th><th>Implemented</th><th>Tested</th></tr>
        <% @defined_routes.each do |route| %>
          <tr>
            <td><%= route.verb %></td>
            <td><%= route.path %></td>
            <td><%= route.requirements[:controller] + '#' + route.requirements[:action] %></td>
            <td><%= implemented_route?(route) ? "YES" : "NO" %></td>
            <td><%= tested_route?(route) ? "YES" : "NO" %></td>
        <% end %>
        </table>
        <p>Routes Defined: <%= @defined_routes.size %><p>
        <p>Routes Implemented: <%= @implemented_routes.size %><p>
        <p>Routes Tested: <%= @tested_routes.size %><p>
      </body>
    </html>
  EOT
end
