require 'rails_helper'

feature 'User can edit his answer', %q(
  In order to correct mistakes
  As an author of the answer
  I want to be able to edit my answer
) do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'Unauthenticated user tries to edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    background { sign_in(user) }

    describe 'owns the answer' do
      given!(:answer) { create(:answer, question: question, user: user) }

      scenario 'tries to bring up the edit form' do
        visit question_path(question)

        within '.answers' do
          expect(page).to_not have_selector 'textarea'

          click_link 'Edit'

          expect(page).to have_selector 'textarea'
        end
      end

      background do
        visit question_path(question)
        click_link 'Edit'
      end

      scenario 'tries to edit it' do
        within '.answers' do
          fill_in 'Body', with: 'edited answer'
          click_button 'Save'

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'tries to edit it with errors' do
        within '.answers' do
          fill_in 'Body', with: ''
          click_button 'Save'

          expect(page).to have_selector 'textarea'
        end

        expect(page).to have_content "Body can't be blank"
      end
      
      scenario 'tries to attach files to answer' do
        within '.answers' do
          attach_file 'File', [
            "#{Rails.root}/spec/rails_helper.rb",
            "#{Rails.root}/spec/spec_helper.rb"
          ]
          click_button 'Save'

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end
    end

    scenario "tries to edit someone else's answer" do
      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end
  end
end
