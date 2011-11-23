require 'rack'

module RouteDog
  module Middleware
    class RouteDog

      include ::RouteDog

      attr_accessor :status, :headers, :response

      def initialize(app)
        load_watched_routes
      end

      def request_path
        @env['PATH_INFO']
      end

      def request_method
        @env['REQUEST_METHOD'].downcase.to_sym
      end

      def identify_controller
        identify_path[:controller]
      end

      def identify_action
        identify_path[:action]
      end

      def identify_path
        Rails.application.routes.recognize_path(request_path, :method => request_method)
      end

      def is_html_response?
        headers["Content-Type"].include?("text/html")
      end

      def tested_action?
        ::RouteDog.route_tested_with_requirements?(identify_controller, identify_action, request_method)
      end
    end
  end
end
