require 'spec_helper'

feature 'Tweets' do
  let(:user) { create(:user) }

  before { login_as user }

  context 'list' do
    scenario 'it shows that user do not have tweets yet' do
      visit '/tweets'
      page.should have_content 'You have no tweets, create one'
    end

    scenario 'user can create tweet when clicks on `create one`' do
      visit '/tweets'
      click_link 'create one'
      page.should have_content 'Create new tweet'
    end
  end

  context 'create' do
    scenario 'it shows form for tweet' do
      visit '/tweets/new'
      page.should have_css 'form.tweet-form'
    end
  end
end
