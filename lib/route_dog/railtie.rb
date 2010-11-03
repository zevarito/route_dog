module RouteDog
  class Railtie < Rails::Railtie
    attr_reader :route_dog_config

    rake_tasks do
      load "tasks/tasks.rake"
    end

    initializer "route_dog.configure_rails_initialization" do |app|
      load_route_dog_configuration
      setup_middlewares(app)
    end

  private

    def setup_middlewares(app)
      app.config.middleware.use RouteDog::Middleware::Watcher  if route_dog_config.has_key?("watcher") && route_dog_config["watcher"]["env"].include?(Rails.env)
      app.config.middleware.use RouteDog::Middleware::Notifier if route_dog_config.has_key?("notifier") && route_dog_config["notifier"]["env"].include?(Rails.env)
    end

    def load_route_dog_configuration
      @route_dog_config ||= YAML.load_file(File.join(Rails.root, 'config', 'route_dog.yml'))
    rescue Errno::ENOENT
      @route_dog_config = {"watcher" => {"env" => ["test"]}, "notifier" => {"env" => ["development"]}}
    end
  end
end
