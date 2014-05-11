require 'spec_helper'

describe Comment do
  it { should belong_to :user }
  it { should belong_to :tweet }

  it { should validate_presence_of(:body) }
  it { should ensure_length_of(:body).is_at_most(140) }

  describe '#user_username' do
    let(:user) { create :user }
    let(:tweet) { user.tweets.create(attributes_for(:tweet)) }
    let(:comment) do
      tweet.comments.build.tap do |comment|
        comment.attributes = attributes_for(:comment)
        comment.user = user
        comment.save
      end
    end

    subject { comment.user_username }

    it 'returns `username` of associated user' do
      expect(subject).to eq user.username
    end
  end
end
