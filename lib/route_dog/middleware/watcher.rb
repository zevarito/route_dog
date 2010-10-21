require 'rack'
require File.join(Rails.root, 'config/routes.rb')

module RouteDog
  module Middleware
    class Watcher
      def initialize(app)
        @app = app
        initialize_yaml_file
      end

      def call(env)
        @env = env

        status, headers, response = @app.call(env)

        store_route if status.to_i < 400

        [status, headers, response]
      end

      def self.config_file
        File.join(Rails.root, 'config', 'route_dog_routes.yml')
      end

    private

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

      def store_route
        @watched_routes[identify_controller] ||= {}
        @watched_routes[identify_controller][identify_action] = request_method.to_s
        File.open(Watcher.config_file, "w") {|file| file.puts(@watched_routes.to_yaml) }
      rescue ActionController::RoutingError
        false
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
    end
  end
end
