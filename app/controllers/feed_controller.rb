class FeedController < ApplicationController
  before_filter :authenticate_user!

  def index
    @tweets = current_user.feed.page(params[:page])
  end
end
