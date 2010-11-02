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
    @instantiated_controllers[requirements[:controller]] = RouteDog.constantize_controller_str(requirements[:controller]).new
  end
end

def report_template
  <<-EOT
    <html>
      <head>
        <style type="text/css">
          body { margin: 0; padding: 0; font:13.34px helvetica,arial,freesans,clean,sans-serif; }
          h1 { background: red; color: #fff; display: block; height: 70px; padding: 10px; width: 100%; }
          table#routes { width: 100%; margin: 0 20px; }
          table#routes th, table#routes td { text-align: left; padding: 5px; }
          table#routes tr:nth-child(odd) { background: #eee;}
          div#route_stats {}
          span.yes { color: green; font-weight: bold }
          span.no { color: red; font-weight: bold }
          div#route_stats { background: #444; color: #fff; padding: 0 0 0 25px; height: 40px; position: absolute; top: 50px; width: 100%; border-bottom: solid 4px #666 }
          div#route_stats span { margin: 0 50px 0 10px; color: #fff; font-weight: bold; }
        </style>
      </head>
      <body>
        <h1>Route Dog - <%= Rails.application.class %> - Routes Report</h1>
        <table id="routes">
        <tr><th>Method</th><th>Path</th><th>Action</th><th>Implemented</th><th>Tested</th></tr>
        <% @defined_routes.each do |route| %>
          <tr>
            <td><%= route.verb %></td>
            <td><%= route.path %></td>
            <td><%= route.requirements[:controller] + '#' + route.requirements[:action] %></td>
            <td><%= implemented_route?(route) ? "<span class='yes'>YES</span>" : "<span class='no'>NO</span>" %></td>
            <td><%= tested_route?(route) ? "<span class='yes'>YES</span>" : "<span class='no'>NO</span>" %></td>
        <% end %>
        </table>
        <div id="route_stats">
          <p>
            <strong>Defined:</strong> <span class="value"><%= @defined_routes.size %></span>
            <strong>Implemented:</strong> <span class="value"><%= @implemented_routes.size %></span>
            <strong>Tested:</strong> <span class="value"><%= @tested_routes.size %></span>
          <p>
        </div>
      </body>
    </html>
  EOT
end
