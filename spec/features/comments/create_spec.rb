require 'rails_helper'

feature 'User can create a comment', %q(
  In order to point out any mistakes and/or ask for clarification
  As an authenticated user
  I want to be able to post a comment on a resource
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries to create a comment' do
      expect(page).to_not have_content 'Can you post a code snippet?'

      within('.question-comments') do
        fill_in 'comment[body]', with: 'Can you post a code snippet?'
        click_button 'Comment'
      end

      expect(page).to have_content 'Your comment was successfully created.'
      expect(page).to have_content 'Can you post a code snippet?'
    end
  end
end
