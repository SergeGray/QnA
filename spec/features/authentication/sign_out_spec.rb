require 'rails_helper'

feature 'User can sign out', %q(
  In order to close the session
  As an authenticated user
  I want to be able to sign out
) do
  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background { sign_in(user) }

    scenario 'tries to sign out' do
      click_link 'Sign out'

      expect(page).to have_content 'Signed out successfully.'
    end
  end

  scenario 'Unauthenticated user tries to sign out' do
    expect(page).to_not have_link 'Sign out'
  end
end
