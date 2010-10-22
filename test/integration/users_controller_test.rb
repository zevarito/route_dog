require File.expand_path(File.dirname(__FILE__) + '/../test_helper.rb')

class UsersControllerTest < ActionController::IntegrationTest

  def setup
    @controller = UsersController.new
  end

  context "Watcher Middleware" do
    context "Non Existent Routes" do
      test "dummy#index" do
        get '/dummy'
        assert_watched_routes_not_include(:dummy, :index, :get)
      end
    end

    context "Not Tested Routes" do
      test "users#index" do
        assert_watched_routes_not_include(:users, :index, :get)
      end

      test "users#new" do
        assert_watched_routes_not_include(:users, :new, :get)
      end

      test "users#create" do
        assert_watched_routes_not_include(:users, :create, :post)
      end

      test "users#show" do
        assert_watched_routes_not_include(:users, :show, :get)
      end

      test "users#edit" do
        assert_watched_routes_not_include(:users, :edit, :get)
      end

      test "users#update" do
        assert_watched_routes_not_include(:users, :update, :put)
      end

      test "users#destroy" do
        assert_watched_routes_not_include(:users, :destroy, :delete)
      end
    end

    context "Tested Routes" do
      test "users#index" do
        get '/users'
        assert_watched_routes_include(:users, :index, :get)
      end

      test "users#new" do
        get '/users/new'
        assert_watched_routes_include(:users, :new, :get)
      end

      test "users#create" do
        post '/users'
        assert_watched_routes_include(:users, :create, :post)
      end

      test "users#show" do
        get '/users/1'
        assert_watched_routes_include(:users, :show, :get)
      end

      test "users#edit" do
        get '/users/1/edit'
        assert_watched_routes_include(:users, :edit, :get)
      end

      test "users#update" do
        put '/users/1'
        assert_watched_routes_include(:users, :update, :put)
      end

      test "users#destroy" do
        delete '/users/1'
        assert_watched_routes_include(:users, :destroy, :delete)
      end
    end
  end
end
