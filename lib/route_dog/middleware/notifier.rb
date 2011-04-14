module RouteDog
  module Middleware
    class Notifier < RouteDog
      def initialize(app)
        @app = app
      end

      def call(env)
        @env = env

        status, headers, @response = @app.call(env)

        append_warning if !::RouteDog.route_tested_with_requirements?(identify_controller, identify_action, request_method)

        [status, headers, @response]
      end

    private

      def append_warning
        @response.each do |part|
          part.gsub!("<body>", "<body>#{warning_template}")
        end
      end

      def no_test_message
        "The Route #{request_method.to_s.upcase} #{identify_controller.to_s}##{identify_action.to_s} -- Has Not Integration Tests!"
      end

      def warning_template
        ERB.new(File.open(File.join(File.dirname(__FILE__), "..", "templates", "warning.html.erb")).read).result(binding)
      end
    end
  end
end
