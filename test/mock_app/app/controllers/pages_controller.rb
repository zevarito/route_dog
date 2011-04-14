class PagesController < ApplicationController
  def home
    render :text => "HOME"
  end

  def about
    render :text => "ABOUT"
  end
end
