require 'spec_helper'

feature 'Feed' do
  let(:user) { create(:user) }

  before { login_as user }

  context 'no friends added' do
    scenario 'it shows `add friends` button' do
      visit '/'
      page.should have_content 'add friends'
    end
  end
end
