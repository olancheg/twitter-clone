module TweetsHelper
  def tweet_title(tweet)
    title = "@#{tweet.user_username}"
    title << " (#{tweet.user_realname})" if tweet.user_realname.present?
    link_to(title, tweet.user)
  end

  def tweet_info(tweet)
    "#{tweet.updated_at} | comments: #{tweet.comments.count}"
  end
end
