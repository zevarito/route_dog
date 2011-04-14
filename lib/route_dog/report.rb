require 'ostruct'

module RouteDog

  class Report

    def initialize
      @defined_routes = Rails.application.routes.routes
    end

    def generate
      remove_not_user_routes!
      map_routes_as_structs!
      calculate_totals
      save_report(template.result(binding))
      open_report_in_browser
    end

    def self.generate
      self.new.generate
    end

    private

    def remove_not_user_routes!
      @defined_routes.reject! { |r| r.path =~ %r{/rails/info/properties} } # Skip the route if it's internal info route
    end

    def template
      ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "report.html.erb")).read)
    end

    def map_routes_as_structs!
      @defined_routes.map! do |route|
        r = OpenStruct.new
        r.verb = route.verb
        r.path = route.path
        r.action = RouteDog.action_string_for_route(route)
        r.tested = RouteDog.route_tested?(route)
        r.implemented = implemented_route?(route)
        r
      end
    end

    def calculate_totals
      @implemented_routes_count = @defined_routes.select {|route| route.implemented }.size
      @tested_routes_count      = @defined_routes.select {|route| route.tested }.size
    end

    def save_report(html_report)
      File.open(report_file, "w+") do |file|
        file.puts(html_report)
      end

      puts("The report was saved in: #{report_file}")
    end

    def open_report_in_browser
      Launchy::Browser.run(report_file) if defined?(Launchy)
    end

    def report_file
      File.join(Rails.root, "tmp", Rails.application.class.to_s.gsub(":", "").concat("RoutesReport.html").underscore)
    end

    def implemented_route?(route)
      controller = find_or_instantiate_controller_for(route)
      if route.requirements.has_key?(:action)
        controller.respond_to?(route.requirements[:action])
      else
        controller.class.instance_methods(false).any?
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
