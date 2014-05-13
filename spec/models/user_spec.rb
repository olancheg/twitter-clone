require 'spec_helper'

describe User do
  let(:user) { create :user }
  let(:another_user) { create :user }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:username) }

  it { should validate_uniqueness_of(:email).case_insensitive }
  it { should validate_uniqueness_of(:username).case_insensitive }

  it { should have_many(:tweets) }
  it { should have_many(:comments) }

  it { should have_many(:bans) }
  it { should have_many(:inverse_bans).with_foreign_key(:target_id).class_name(:Ban) }

  it { should have_many(:banning_users).through(:inverse_bans).source(:user) }
  it { should have_many(:banned_users).through(:bans).source(:target) }

  it { should have_many(:outgoing_friend_requests).class_name(:Friendship).with_foreign_key(:sender_id) }
  it { should have_many(:incoming_friend_requests).class_name(:Friendship).with_foreign_key(:recipient_id) }

  def make_friendship(a = user, b = another_user)
    a.send_friend_request(b)
    b.send_friend_request(a)
  end

  describe '.search' do
    subject { described_class.search(q: 'super') }

    context 'by username' do
      before { user.update_attributes(username: 'superhero') }
      it { should include user }
    end

    context 'by realname' do
      before { user.update_attributes(username: 'Super Jack') }
      it { should include user }
    end
  end

  describe '#friends' do
    subject { user.friends }
    before { make_friendship }

    it 'returns users' do
      expect(subject).to include another_user
    end
  end

  describe '#send_friend_request' do
    subject { user.method(:send_friend_request) }

    it 'creates outgoing request' do
      expect { subject.(another_user) }.to \
        change{ user.outgoing_friend_requests.count }.from(0).to(1)
    end

    it 'raises an error on sending request to yourself' do
      expect { subject.(user) }.to raise_error ActiveRecord::RecordInvalid
    end

    context 'recipient is banned user' do
      before { another_user.add_to_blacklist(user) }

      it 'does not create record' do
        expect { subject.(another_user) }.to raise_error ActiveRecord::RecordInvalid
      end
    end
  end

  describe '#cancel_friendship' do
    subject { user.method(:cancel_friendship) }

    before { make_friendship }

    it 'creates destroys friendship record' do
      expect { subject.(another_user) }.to \
        change{ user.friends.count }.from(1).to(0)
    end
  end

  describe '#is_a_friend?' do
    subject { user.method(:is_a_friend?) }

    let(:definetely_not_a_friend) { create :user }

    before { make_friendship }

    it 'returns false if there is no friendship' do
      expect(subject.(definetely_not_a_friend)).to be_false
    end

    it 'returns true if there is friendship relations' do
      expect(subject.(another_user)).to be_true
    end
  end

  describe '#has_incoming_friend_request?' do
    subject { user.method(:has_incoming_friend_request?) }

    it 'returns false if there is no request' do
      expect(subject.(another_user)).to be_false
    end

    it 'returns true if there is a request' do
      another_user.send_friend_request(user)
      expect(subject.(another_user)).to be_true
    end
  end

  describe '#has_outgoing_friend_request?' do
    subject { user.method(:has_outgoing_friend_request?) }

    it 'returns false if there is no request' do
      expect(subject.(another_user)).to be_false
    end

    it 'returns true if there is a request' do
      user.send_friend_request(another_user)
      expect(subject.(another_user)).to be_true
    end
  end

  describe '#incoming_requests_count' do
    let(:friend) { create :user }

    subject { user.incoming_requests_count }

    before do
      another_user.send_friend_request(user)
      make_friendship(user, friend)
    end

    it 'returns count of incoming friend requests that has not been accepted' do
      expect(subject).to be 1
    end
  end

  describe '#outgoing_requests_count' do
    let(:friend) { create :user }

    subject { user.outgoing_requests_count }

    before do
      user.send_friend_request(another_user)
      make_friendship(user, friend)
    end

    it 'returns count of outgoing friend requests that has not been accepted' do
      expect(subject).to be 1
    end
  end

  describe '#add_to_blacklist' do
    subject { user.method(:add_to_blacklist) }
    before { make_friendship }

    it 'destroys outgoing friend request' do
      expect { subject.(another_user) }.to \
        change { user.outgoing_friend_requests.count }.from(1).to(0)
    end

    it 'adds to `banned_users` list' do
      expect { subject.(another_user) }.to \
        change { user.banned_user_ids }.from([]).to([another_user.id])
    end

    it 'banning user appears in `banning_users`' do
      expect { subject.(another_user) }.to \
        change { another_user.banning_user_ids }.from([]).to([user.id])
    end
  end

  describe '#remove_from_blacklist' do
    subject { user.method(:remove_from_blacklist) }

    before { make_friendship }
    before { user.add_to_blacklist(another_user) }

    it 'does not create outgoing friend request' do
      expect { subject.(another_user) }.not_to \
        change { user.outgoing_friend_requests.count }
    end

    it 'removes user from `banned_users` list' do
      expect { subject.(another_user) }.to \
        change { user.banned_users.count }.from(1).to(0)
    end
  end

  describe '#feed' do
    subject { user.feed }

    let(:mom) { create :user }
    let(:dad) { create :user }

    before { make_friendship(user, dad) and make_friendship(user, mom) }

    before do
      5.times do
        mom.tweets.create(attributes_for(:tweet))
        dad.tweets.create(attributes_for(:tweet))
        another_user.tweets.create(attributes_for(:tweet))
      end
    end

    it 'returns tweets from first friend' do
      expect(subject.pluck(:id)).to include *mom.tweet_ids
    end

    it 'returns tweets from second friend' do
      expect(subject.pluck(:id)).to include *dad.tweet_ids
    end

    it 'does not return tweets from not a friend' do
      expect(subject.pluck(:id)).not_to include *another_user.tweet_ids
    end
  end
end
