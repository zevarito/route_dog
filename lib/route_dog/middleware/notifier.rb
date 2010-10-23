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

      def no_test_message
        "The Route #{request_method.to_s.upcase} #{identify_controller.to_s}##{identify_action.to_s} -- Has Not Integrational Tests!"
      end

      def warning_html
        <<-EOT
          <div style="display: block; height:70px;"></div>
          <div id="route_dog_warning" style="display: block; width: 100%; height: 70px; text-align: center; margin:0; position:absolute; top:0; background: red; font-size: 18px; font-weight: bold">
            <h1 style="color: #fff; font-size: 20px; margin: 20px 0 35px">#{no_test_message}</h1>
          </div>
        EOT
      end
    end
  end
end
