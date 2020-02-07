require 'rails_helper'

feature 'User can sign in with oauth providers', %q(
  In order to ask question
  As an unauthenticated user
  I want to be able to sign in using oauth providers
) do
  given!(:user) { create(:user) }

  describe 'Registered user' do
    background { mock_auth_hash(:github, email: user.email) }

    scenario 'tries to sign in with github for the first time' do
      visit new_user_session_path
      click_link 'Sign in with GitHub'
      
      expect(page).to have_content(
        'Successfully authenticated from Github account'
      )
      expect(page).to have_content('Sign out')
    end
  end

  scenario 'Unregistered user tries to sign in with github'

  scenario 'User does not give the app github permission'
end
