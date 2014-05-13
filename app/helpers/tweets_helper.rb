module TweetsHelper
  def tweet_title(tweet)
    link_to user_title(tweet.user), tweet.user
  end

  def tweet_info(tweet)
    "#{tweet.updated_at} | comments: #{tweet.comments.count}"
  end
end
