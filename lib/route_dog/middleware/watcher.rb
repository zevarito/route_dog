require 'rack'

module RouteDog
module Middleware
  class Watcher
    def initialize(app)
      @app = app
    end

    def call(env)
      @env = env

      @app.call(env)
    end
  end
end
end
