require 'spec_helper'

describe TweetsHelper do
  let(:user) { create :user }
  let(:tweet) { user.tweets.create(attributes_for(:tweet)) }

  describe '.tweet_title' do
    before { helper.should_receive(:user_title) }

    it 'wrapped with `a` tag' do
      expect(helper.tweet_title(tweet)).to include %(a href="/users/#{user.id}")
    end
  end

  describe '.tweet_info' do
    before do
      3.times do
        tweet.comments.create(attributes_for(:comment))
      end
    end

    it 'combines `updated_at` and comments count info' do
      expect(helper.tweet_info(tweet)).to eq "#{tweet.updated_at} | comments: 3"
    end
  end
end
