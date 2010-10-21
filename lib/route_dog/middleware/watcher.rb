require 'rack'
require File.join(Rails.root, 'config/routes.rb')

module RouteDog
  module Middleware
    class Watcher < RouteDog
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

    private

      def store_route
        @watched_routes[identify_controller] ||= {}
        @watched_routes[identify_controller][identify_action] = request_method.to_s
        File.open(Watcher.config_file, "w") {|file| file.puts(@watched_routes.to_yaml) }
      rescue ActionController::RoutingError
        false
      end
    end
  end
end
