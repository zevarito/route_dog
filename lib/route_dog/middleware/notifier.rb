module RouteDog
  module Middleware
    class Notifier < RouteDog
      def initialize(app)
        @app = app
        super
      end

      def call(env)
        @env = env

        status, headers, @response = @app.call(env)

        append_warning if !route_tested?

        [status, headers, @response]
      end

      def append_warning
        @response.each do |part|
          part.gsub!("<body>", "<body>#{warning_html}")
        end
      end

      def warning_html
        <<-EOT
          <div id="route_dog_warning" style="display: block; width: 100%; height: 100px; text-align: center; color: red; font-size: 18px; font-weight: bold">
            <h1 style="color: #fff;">The Route -- Has Not Integrational Tests!</h1>
          </div>
        EOT
      end
    end
  end
end
