class UsersController < ApplicationController

  def show_posts
    @user = User.find(params[:id])
    @posts = @user.posts
  end

end