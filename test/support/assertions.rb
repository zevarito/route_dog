def assert_watched_routes_include(controller, action, method)
  begin
    routes = YAML.load_file(RouteDog::Middleware::RouteDog.config_file)
    raise if !routes[controller.to_s][action.to_s].include?(method.to_s)
    raise if routes[controller.to_s][action.to_s].reject {|e| e != method.to_s}.size != 1
  rescue
    assert false, "Expected Watched Routes To Include {:controller => :#{controller}, :action => :#{action}, :method => :#{method}} Only One Time."
  end
end

def assert_watched_routes_not_include(controller, action, method = :get)
  begin
    routes = YAML.load_file(RouteDog::Middleware::RouteDog.config_file)
    routes[controller.to_s][action.to_s].include?(method.to_s)
    assert false
  rescue Test::Unit::AssertionFailedError
    assert false, "Expected Watched Routes To Not include {:controller => :#{controller}, :action => :#{action}, :method => :#{method}}."
  rescue
    assert true
  end
end
