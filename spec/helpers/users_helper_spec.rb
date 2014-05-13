require 'spec_helper'

describe UsersHelper do
  let(:user) { create :user }

  describe '.user_title' do
    it 'always returns `username`' do
      expect(helper.user_title(user)).to include "@#{user.username}"
    end

    context 'user has real name' do
      it 'returns `realname`' do
        expect(helper.user_title(user)).to include "(#{user.realname})"
      end
    end

    context 'user has not set real name' do
      before { user.update_attributes(realname: nil) }

      it 'does not return `realname`' do
        expect(helper.user_title(user)).not_to include "()"
      end
    end
  end

  describe '.incoming_requests_title' do
    before { user.stub(:incoming_requests_count).and_return(10) }
    subject { helper.incoming_requests_title(user) }
    it { should eq 'Incoming requests (10)' }
  end

  describe '.outgoing_requests_title' do
    before { user.stub(:outgoing_requests_count).and_return(6) }
    subject { helper.outgoing_requests_title(user) }
    it { should eq 'Outgoing requests (6)' }
  end

  describe '.dropdown_friends_link' do
    subject { helper.dropdown_friends_link(user) }

    context 'no friend requests' do
      it 'returns just `Friends` link' do
        expect(subject).to include 'Friends'
        expect(subject).not_to include '('
        expect(subject).to include '/friendships'
        expect(subject).not_to include '/friendships/incoming'
      end
    end

    context 'there are some friend requests' do
      before do
        2.times { create(:user).send_friend_request(user) }
      end

      it 'returns `Friends` link with count and pointing to incoming-friend-requests page' do
        expect(subject).to include 'Friends (2)'
        expect(subject).to include '/friendships/incoming'
      end
    end
  end
end
