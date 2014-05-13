class BlacklistsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @banning_users = current_user.banning_users
    @banned_users  = current_user.banned_users
  end

  def create
    current_user.add_to_blacklist(user)
    redirect_to user
  end

  def destroy
    current_user.remove_from_blacklist(user)
    redirect_to user
  end

private

  def user
    User.find(params[:id])
  end
end
