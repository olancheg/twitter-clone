require 'spec_helper'

describe Tweet do
  it { should validate_presence_of(:body) }
  it { should ensure_length_of(:body).is_at_most(140) }

  it { should belong_to(:user) }
  it { should have_many(:comments) }

  let(:user) { create :user }
  let(:tweet) { user.tweets.create(attributes_for(:tweet)) }

  describe '#add_comment' do
    let(:result) { tweet.add_comment({ body: 'text' }, user) }

    it 'creates comment' do
      expect(result).to be_instance_of Comment
      expect(result).to be_persisted
      expect(result.body).to eq 'text'
    end
  end

  describe '#user_username' do
    subject { tweet.user_username }

    it 'returns `username` of associated user' do
      expect(subject).to eq user.username
    end
  end

  describe '#user_realname' do
    subject { tweet.user_realname }

    it 'returns `realname` of associated user' do
      expect(subject).to eq user.realname
    end
  end
end
