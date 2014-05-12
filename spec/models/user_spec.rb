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

  it { should have_many(:outgoing_friend_requests) }
  it { should have_many(:incoming_friend_requests) }

  describe '#friends' do
    subject { user.friends }

    before do
      user.outgoing_friend_requests.create(sender: user, recipient: another_user)
      user.incoming_friend_requests.create(sender: another_user, recipient: user)
    end

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
  end

  describe '#accept_friend_request' do
    subject { user.method(:accept_friend_request) }

    before { another_user.send_friend_request(user) }

    it 'creates outgoing request' do
      expect { subject.(another_user) }.to \
        change{ user.outgoing_friend_requests.count }.from(0).to(1)
    end
  end
end
