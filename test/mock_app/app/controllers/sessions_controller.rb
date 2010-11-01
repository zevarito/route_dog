class SessionsController < ApplicationController
  def logout
    redirect_to '/'
  end
end
