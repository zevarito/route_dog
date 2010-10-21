def assert_watched_routes_include(controller, action, method)
  begin
    YAML.load_file(RouteDog::Middleware::RouteDog.config_file)[controller.to_s][action.to_s][method.to_s]
    assert true
  rescue
    assert false, "Expected Watched routes include {:controller => :#{controller}, :action => :#{action}, :method => :#{method}}"
  end
end

def assert_watched_routes_not_include(controller, action, method = :get)
  begin
    YAML.load_file(RouteDog::Middleware::RouteDog.config_file)[controller.to_s][action.to_s][method.to_s]
    assert false, "Expected Watched routes NOT include {:controller => :#{controller}, :action => :#{action.to_sym}, :method => :#{method.to_sym}}"
  rescue
    assert true
  end
end
