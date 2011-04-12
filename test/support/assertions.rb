def assert_watched_routes_include(controller, action, method)
  begin
    routes = YAML.load_file(RouteDog.config_file)
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
  rescue ActiveSupport::TestCase::Assertion
    assert false, "Expected Watched Routes To Not include {:controller => :#{controller}, :action => :#{action}, :method => :#{method}}."
  rescue
    assert true
  end
end

def assert_notify_for(controller, action, method = :get)
  html_notification = Nokogiri::HTML(response.body).search('div#route_dog_warning')
  assert html_notification.any?, "Expected {:controller => :#{controller}, :action => :#{action}, :method => :#{method}} Notify That The Route Has Not Tests"
end

def assert_not_notify_for(controller, action, method = :get)
  html_notification = Nokogiri::HTML(response.body).search('div#route_dog_warning')
  assert !html_notification.any?, "Expected {:controller => :#{controller}, :action => :#{action}, :method => :#{method}} To Not Notify That The Route Has Not Tests"
end
