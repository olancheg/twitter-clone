class TweetsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_resource, except: [:index, :show]

  def new() end

  def index
    @tweets = current_user.tweets.page(params[:page])
  end

  def show
    @tweet = Tweet.find(params[:id])
  end

  def create
    if @tweet.save
      redirect_to @tweet
    else
      render :new
    end
  end

  def destroy
    @tweet.destroy

    redirect_to :tweets
  end

private

  def find_resource
    @tweet = if params[:id]
      current_user.tweets.find(params[:id])
    else
      current_user.tweets.build(params[:tweet])
    end
  end
end
