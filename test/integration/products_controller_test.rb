require File.expand_path(File.dirname(__FILE__) + '/../test_helper.rb')

class ProductsControllerTest < ActionController::IntegrationTest

  def setup
    @controller = ProductsController.new
  end

  context "Notifier Middleware" do
    test "Show notification of a not tested GET request" do
      get "/products/new"

      assert_notify_for(:products, :new, :get)
    end

    test "Show notification of a not tested POST request" do
      post "/products"

      assert_notify_for(:products, :create, :post)
    end

    test "Show notification of a not tested DELETE request" do
      delete "/products/1"

      assert_notify_for(:products, :destroy, :delete)
    end

    test "Show notification of a not tested PUT request" do
      put "/products/1"

      assert_notify_for(:products, :update, :put)
    end

    test "Not show notifications for tested routes" do
      get "/products"
      assert_watched_routes_include(:products, :index, :get)
      get "/products"
      assert_not_notify_for(:products, :index, :get)
    end
  end
end
