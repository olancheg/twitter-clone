class FriendshipsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @friends = current_user.friends.order(:username).page(params[:page])
  end

  def incoming
    @requests = current_user
      .incoming_friend_requests
      .without_sender_ids(current_user.friend_ids)
      .page(params[:page])
  end

  def outgoing
    @requests = current_user
      .outgoing_friend_requests
      .without_recipient_ids(current_user.friend_ids)
      .page(params[:page])
  end

  def create
    current_user.send_friend_request(user)
    redirect_to user
  end

  def destroy
    current_user.cancel_friendship(user)
    redirect_to :friendships
  end

private

  def user
    User.find(params[:id])
  end
end
