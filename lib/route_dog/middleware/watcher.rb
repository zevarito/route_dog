module RouteDog
  module Middleware
    class Watcher < RouteDog
      def initialize(app)
        @app = app
        super
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
        @watched_routes[identify_controller][identify_action] ||= []
        @watched_routes[identify_controller][identify_action] << request_method.to_s
        @watched_routes[identify_controller][identify_action].uniq!
        write_watched_routes
      rescue ActionController::RoutingError
        false
      end
    end
  end
end
