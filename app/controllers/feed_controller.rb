class FeedController < ApplicationController
  before_filter :authenticate_user!

  def index
    @tweets = Tweet.order('created_at DESC').limit(50)
  end
end
