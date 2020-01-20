require 'rails_helper'

feature 'User can edit his question', %q(
  In order to correct mistakes
  As an author of the question
  I want to be able to edit my question
) do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Unauthenticated user tries to edit a question' do
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
    end

    describe 'owns the question' do
      given!(:question) { create(:question, user: user) }

      scenario 'tries to bring up the edit form' do
        visit questions_path

        within '.questions' do
          expect(page).to_not have_selector 'textarea'

          click_link 'Edit'

          expect(page).to have_selector 'textarea'
        end
      end

      background do
        visit questions_path
        click_link 'Edit'
      end

      scenario 'tries to edit it' do
        within '.questions' do
          fill_in 'Title', with: 'edited question title'
          fill_in 'Body', with: 'edited question body'
          click_button 'Save'

          expect(page).to_not have_content question.title
          expect(page).to_not have_content question.body
          expect(page).to have_content 'edited question title'
          expect(page).to have_content 'edited question body'
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'tries to edit it with errors' do
        within '.questions' do
          fill_in 'Body', with: ''
          click_button 'Save'

          expect(page).to have_selector 'textarea'
        end

        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit someone else's answer" do
      visit questions_path

      expect(page).to_not have_link 'Edit'
    end
  end
end
