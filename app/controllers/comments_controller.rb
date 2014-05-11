class CommentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_tweet

  def create
    @comment = @tweet.comments.build(params[:comment])
    @comment.user = current_user
    @comment.save

    redirect_to @tweet
  end

private

  def find_tweet
    @tweet = Tweet.find(params[:tweet_id])
  end
end
