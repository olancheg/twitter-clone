class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @users = User.search(params).page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @tweets = @user.tweets.page(params[:page])
  end
end
