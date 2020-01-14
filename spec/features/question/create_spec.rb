require 'rails_helper'

feature 'User can create question', %q(
  In order to get answer from the community
  As an authenticated user
  I want to be able to ask a question
) do
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit questions_path
      click_link 'Ask a question'
    end

    scenario 'tries to create a question' do
      fill_in 'Title', with: 'How do I do this'
      fill_in 'Body', with: 'Help'
      click_button 'Submit'

      expect(page).to have_content 'Your question was successfully created.'
      expect(page).to have_content 'How do I do this'
      expect(page).to have_content 'Help'
    end

    scenario 'tries to create a question with errors' do
      click_button 'Submit'

      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to create a question' do
    visit questions_path

    expect(page).to_not have_link 'Ask a question'
  end
end
