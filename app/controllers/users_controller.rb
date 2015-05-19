class UsersController < ApplicationController

  def show_posts
    @user = User.find(params[:id])
    @posts = @user.posts
  end

  def show_users
    @users = User.all
  end

end