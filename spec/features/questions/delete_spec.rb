require 'rails_helper'

feature 'User can delete their question', %q(
  In order to prevent bad or outdated questions from being seen
  As an author of the question
  I want to be able to delete my question
) do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authorized user' do
    background { sign_in(user) }

    describe 'owns a question' do
      given!(:question) { create(:question, user: user) }

      scenario 'and tries to delete it' do
        visit questions_path

        expect(page).to have_content question.title

        click_link 'Destroy'

        expect(page).to have_content 'Your question was successfully destroyed'
        expect(page).to_not have_content question.title
      end
    end

    scenario "tries to delete somebody else's question" do
      visit questions_path

      expect(page).to have_content question.title
      expect(page).to_not have_link "Destroy"
    end
  end

  scenario "Guest tries to delete a question" do
    visit questions_path

    expect(page).to have_content question.title
    expect(page).to_not have_link "Destroy"
  end
end
