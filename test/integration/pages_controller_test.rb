require File.expand_path(File.dirname(__FILE__) + '/../test_helper.rb')

class PagesControllerTest < ActionController::IntegrationTest

  def setup
    @controller = PagesController.new
  end

  context "Hiting routes" do
    test "Hit a route with an unespecified action" do
      get "/pages/home"
    end
  end
end
