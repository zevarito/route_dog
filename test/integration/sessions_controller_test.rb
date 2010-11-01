require File.expand_path(File.dirname(__FILE__) + '/../test_helper.rb')

class SessionsControllerTest < ActionController::IntegrationTest

  def setup
    @controller = SessionsController.new
  end

  context "Watcher Middleware" do
    test "Identifying routes of actions that respond to more than one method" do
      get "/sessions/1/logout"
      delete "/sessions/1/logout"

      assert_watched_routes_include(:sessions, :logout, :get)
      assert_watched_routes_include(:sessions, :logout, :delete)
    end
  end
end
