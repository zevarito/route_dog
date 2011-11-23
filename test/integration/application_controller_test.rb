require File.expand_path(File.dirname(__FILE__) + '/../test_helper.rb')

class ApplicationControllerTest < ActionController::IntegrationTest

  def setup
    @controller = ApplicationController.new
  end

  context "Asset pipeline" do
    test "should work fine with asset pipeline" do
      get "/assets/rails.png"
    end
  end
end
