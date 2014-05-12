class CommentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_tweet

  def create
    @comment = @tweet.add_comment(params[:comment], current_user)

    if @comment.persisted?
      redirect_to @tweet
    else
      render 'tweets/show'
    end
  end

private

  def find_tweet
    @tweet = Tweet.find(params[:tweet_id])
  end
end
