def assert_watched_routes_include(controller, action, method)
  begin
    routes = YAML.load_file(RouteDog::Middleware::RouteDog.config_file)
    raise if !routes[controller.to_s][action.to_s].include?(method.to_s)
  rescue
    assert false, "Expected Watched routes include {:controller => :#{controller}, :action => :#{action}, :method => :#{method}}"
  end
end

def assert_watched_routes_not_include(controller, action, method = :get)
  begin
    routes = YAML.load_file(RouteDog::Middleware::RouteDog.config_file)
    raise if routes[controller.to_s][action.to_s].include?(method.to_s)
  rescue
    assert true
  end
end
