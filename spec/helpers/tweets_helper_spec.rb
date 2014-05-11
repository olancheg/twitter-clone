require 'spec_helper'

describe TweetsHelper do
  let(:user) { create :user }
  let(:tweet) { user.tweets.create(attributes_for(:tweet)) }

  describe '.tweet_title' do
    it 'always returns `username`' do
      expect(helper.tweet_title(tweet)).to include "@#{user.username}"
    end

    context 'user has real name' do
      it 'returns `realname`' do
        expect(helper.tweet_title(tweet)).to include "(#{user.realname})"
      end
    end

    context 'user has not set real name' do
      before { user.update_attributes(realname: nil) }

      it 'does not return `realname`' do
        expect(helper.tweet_title(tweet)).not_to include "()"
      end
    end

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
