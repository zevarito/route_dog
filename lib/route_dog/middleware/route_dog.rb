require 'rack'
require File.join(Rails.root, 'config/routes.rb')

module RouteDog
  module Middleware
    class RouteDog
      def self.config_file
        File.join(Rails.root, 'config', 'route_dog_routes.yml')
      end

      def initialize_yaml_file
        @watched_routes = YAML.load_file(Watcher.config_file)
      rescue Errno::ENOENT
        @watched_routes = {}
      end

      def request_path
        @env['REQUEST_URI']
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

      def route_tested?
        initialize_yaml_file
        begin
          @watched_routes[identify_controller.to_s][identify_action.to_s].include?(request_method.to_s)
        rescue
          false
        end
      end

      def identify_path
        Rails.application.routes.recognize_path(request_path, :method => request_method)
      end
    end
  end
end
