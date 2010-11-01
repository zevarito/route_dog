require 'route_dog/middleware'

module RouteDog
  def self.config_file
    File.join(Rails.root, 'config', 'route_dog_routes.yml')
  end

  def self.load_watched_routes
    YAML.load_file(config_file)
  rescue Errno::ENOENT
    {}
  end

  def self.write_watched_routes(routes)
    File.open(config_file, "w+") {|file| file.puts(routes.to_yaml) }
  end

  def self.route_tested?(controller, action, method)
    begin
      load_watched_routes[controller.to_s.downcase][action.to_s.downcase].include?(method.to_s.downcase)
    rescue
      false
    end
  end
end
