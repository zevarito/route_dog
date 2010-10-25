require 'route_dog/middleware'

module RouteDog
  def self.config_file
    File.join(Rails.root, 'config', 'route_dog_routes.yml')
  end

  def load_watched_routes
    @watched_routes = YAML.load_file(RouteDog.config_file)
  rescue Errno::ENOENT
    @watched_routes = {}
  end

  def write_watched_routes
    File.open(RouteDog.config_file, "w+") {|file| file.puts(@watched_routes.to_yaml) }
  end
end
