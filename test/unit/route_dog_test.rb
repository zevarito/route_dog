require File.expand_path(File.dirname(__FILE__) + '/../test_helper.rb')

class RouteDogTest < Test::Unit::TestCase
  context "Constantize controllers as it comes from routes" do
    test "simples" do
      assert_equal UsersController, RouteDog.constantize_controller_str("users")
    end

    test "with composite names" do
      assert_equal ProjectSettingsController, RouteDog.constantize_controller_str("project_settings")
    end

    test "named spaced simples" do
      assert_equal Admin::UsersController, RouteDog.constantize_controller_str("admin/users")
    end

    test "named spaced with composite names" do
      assert_equal Admin::ProjectSettingsController, RouteDog.constantize_controller_str("admin/project_settings")
    end

    test "named spaced deeply" do
      assert_equal Admin::Blogs::PostsController, RouteDog.constantize_controller_str("admin/blogs/posts")
    end
  end

  context "Identify tested routes" do

    def write_tested_routes_yaml(hash)
      File.open(RouteDog.watched_routes_file, "w+") {|file| file.puts(hash.to_yaml) }
    end

    test "identify routes that respond to get method" do
      write_tested_routes_yaml("products" => {"index" => ["get"]})
      assert_equal true, RouteDog.route_tested_with_requirements?(:products, :index, :get)
    end

    test "identify routes that respond to any method" do
      write_tested_routes_yaml("products" => {"index" => ["get"]})
      assert_equal true, RouteDog.route_tested_with_requirements?(:products, :index, nil)
    end
  end
end
