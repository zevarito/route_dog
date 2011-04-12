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
    save_and_open_report_in_browser(ERB.new(report_template).result(binding))
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

def report_template
  <<-EOT
    <html>
      <head>
        <style type="text/css">
          html, body, div, span, applet, object, iframe, h1, h2, h3, h4, h5, h6, p, blockquote, pre,
          a, abbr, acronym, address, big, cite, code, del, dfn, em, font, img, ins, kbd, q, s, samp,
          small, strike, strong, sub, sup, tt, var, b, u, i, center, dl, dt, dd, ol, ul, li, fieldset,
          form, label, legend, table, caption, tbody, tfoot, thead, tr, th, td {
          margin: 0; padding: 0; border: 0; outline: 0; font-size: 100%; vertical-align: baseline; background: transparent;}

          body { margin: 0; padding: 0; font:15.34px helvetica,arial,freesans,clean,sans-serif; }
          #header { background: red; color: #fff; display: block; height: 70px; }
          h1 { font-size: 18px; padding: 10px 0 0 25px; }
          table#routes { width: 100%; padding: 40px 25px 0; }
          table#routes th, table#routes td { text-align: left; padding: 5px; }
          table#routes tr:nth-child(odd) { background: #eee;}
          div#route_stats {}
          span.yes { color: green; font-weight: bold }
          span.no { color: red; font-weight: bold }
          div#route_stats { background: #444; color: #fff; height: 30px; position: absolute; top: 50px; width: 100%; border-bottom: solid 4px #666 }
          div#route_stats p { padding: 10px 0 0 25px; }
          div#route_stats span { margin: 0 50px 0 10px; color: #fff; font-weight: bold; }
          div#route_stats span.zero_routes { background: #666; padding: 2px; 5px; }
        </style>
      </head>
      <body>
        <div id="header">
          <h1>Route Dog - <%= Rails.application.class.to_s.gsub(/::/, ' ') %> - Routes Report</h1>
        </div>
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
              <% if @tested_routes.size == 0 %><span class="zero_routes">You have 0 routes tested, may be you should run your Integrational Tests First!</span><% end %>
          <p>
        </div>
      </body>
    </html>
  EOT
end
