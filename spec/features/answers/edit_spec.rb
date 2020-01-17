require 'rails_helper'

feature 'User can edit his answer', %q(
  In order to correct mistakes
  As an author of the answer
  I want to be able to edit my answer
) do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user tries to edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edits his answer' do
      click_link 'Edit'

      within '.answers' do
        fill_in 'Body', with: 'edited answer'
        click_button 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors'
    scenario "tries to edit someone else's answer"
  end
end
