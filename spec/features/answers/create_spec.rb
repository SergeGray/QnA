require 'rails_helper'

feature 'User can answer a question', %q(
  In order to help people with their problems
  As an authenticated user
  I want to be able to answer a question
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries to answer a question' do
      expect(page).to_not have_content 'Just use puts.'

      fill_in 'Body', with: 'Just use puts.'
      click_button 'Answer'

      expect(page).to have_content 'Your answer was successfully created.'
      expect(page).to have_content 'Just use puts.'
    end

    scenario 'tries to answer a question with errors' do
      click_button 'Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to answer a question' do
    visit question_path(question)

    expect(page).to_not have_button 'Answer'
  end
end
