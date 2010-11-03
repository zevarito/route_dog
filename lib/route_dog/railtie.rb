module RouteDog
  class Railtie < Rails::Railtie
    rake_tasks do
      load "tasks/tasks.rake"
    end

    initializer "route_dog.configure_rails_initialization" do |app|
      setup_middlewares(app)
    end

    def setup_middlewares(app)
      app.config.middleware.use RouteDog::Middleware::Watcher  if Rails.env.test?
      app.config.middleware.use RouteDog::Middleware::Notifier if Rails.env.development? || Rails.env.test?
    end
  end
end
