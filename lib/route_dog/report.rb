module RouteDog
  class Report

    def initialize
      @implemented_routes = []
      @tested_routes = []
      @defined_routes = Rails.application.routes.routes
    end

    def generate
      clean_routes
      save_and_open_report_in_browser(template.result(binding))
    end

    def self.generate
      self.new.generate
    end

    private

    def clean_routes
      @defined_routes.reject! { |r| r.path =~ %r{/rails/info/properties} } # Skip the route if it's internal info route
    end

    def template
      ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "report.html.erb")).read)
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
  end
end
