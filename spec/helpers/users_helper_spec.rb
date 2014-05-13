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
end
