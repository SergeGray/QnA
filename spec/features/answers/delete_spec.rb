require 'rails_helper'

feature 'User can delete their answer', %q(
  In order to prevent bad or outdated answers from being seen
  As an author of the answer
  I want to be able to delete my answer
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated User', js: true do
    background { sign_in(user) }

    describe 'owns an answer' do
      given!(:answer) { create(:answer, question: question, user: user) }

      scenario 'and tries to delete it' do
        visit question_path(question)

        expect(page).to have_content answer.body

        click_link 'Destroy'

        expect(page).to have_content 'Your answer was successfully destroyed'
        expect(page).to_not have_content answer.body
      end
    end

    scenario "tries to delete somebody else's answer" do
      visit question_path(question)

      expect(page).to have_content answer.body
      expect(page).to_not have_link 'Destroy'
    end
  end

  scenario "Guest tries to delete an answer" do
    visit question_path(question)

    expect(page).to have_content answer.body
    expect(page).to_not have_link 'Destroy'
  end
end
