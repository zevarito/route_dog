module RouteDog
  class Railtie < Rails::Railtie

    rake_tasks do
      load "tasks/tasks.rake"
    end

    initializer "route_dog.configure_rails_initialization" do |app|
      setup_middlewares(app)
    end

  private

    def setup_middlewares(app)
      if route_dog_configuration.fetch("watcher", {}).fetch("env", []).include?(Rails.env)
        app.config.middleware.use RouteDog::Middleware::Watcher
      end

      if route_dog_configuration.fetch("notifier", {}).fetch("env", []).include?(Rails.env)
        app.config.middleware.use RouteDog::Middleware::Notifier
      end
    end

    def route_dog_configuration
      YAML.load_file(RouteDog.config_file)
    rescue Errno::ENOENT
      {"watcher" => {"env" => ["test"]}, "notifier" => {"env" => ["development"]}}
    end
  end
end
