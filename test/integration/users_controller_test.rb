require File.expand_path(File.dirname(__FILE__) + '/../test_helper.rb')

class UsersControllerTest < ActionController::IntegrationTest

  def setup
    @controller = UsersController.new
  end

  test "listing users" do
    get '/users'
  end
end
