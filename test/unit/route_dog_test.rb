require File.expand_path(File.dirname(__FILE__) + '/../test_helper.rb')

class RouteDogTest < Test::Unit::TestCase
  test "constantize controllers as it comes from routes" do
    assert_equal UsersController, RouteDog.constantize_controller_str("users")
  end

  test "constantize named_spaces controllers as it comes from routes" do
    assert_equal Admin::UsersController, RouteDog.constantize_controller_str("admin/users")
    assert_equal Admin::Blogs::PostsController, RouteDog.constantize_controller_str("admin/blogs/posts")
  end
end
