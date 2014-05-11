class TweetsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_resource, except: :index

  def index
    @tweets = current_user.tweets
  end

  def new() end
  def show() end
  def edit() end

  def create
    if @tweet.save
      redirect_to @tweet
    else
      render :new
    end
  end

  def update
    if @tweet.update_attributes(params[:tweet])
      redirect_to @tweet
    else
      render :edit
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
