require 'rails_helper'

feature 'User can delete their links', %q(
  In order to prevent bad or outdated links from being seen
  As an author of the resource
  I want to be able to delete my links
) do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:question_link) { create(:link, linkable: question) }
  given!(:answer_link) { create(:link, :yandex, linkable: answer) }

  describe 'Authorized user', js: true do
    background { sign_in(user) }

    describe 'owns a question' do
      given(:question) { create(:question, user: user) }

      scenario 'tries to delete a link from it' do
        visit question_path(question)

        within ".question-links" do
          expect(page).to have_link question_link.name

          click_link 'Delete link'

          expect(page).to_not have_link question_link.name
        end
      end
    end

    describe 'owns an answer' do
      given(:answer) { create(:answer, question: question, user: user) }

      scenario 'tries to delete a link from it' do
        visit question_path(question)

        within ".answer-#{answer.id}-links" do
          expect(page).to have_link answer_link.name

          click_link 'Delete link'

          expect(page).to_not have_link answer_link.name
        end
      end
    end

    scenario "tries to delete a link from someone else's question" do
      visit question_path(question)

      within ".answer-#{answer.id}-links" do
        expect(page).to_not have_link 'Delete link'
      end
    end

    scenario "tries to delete a link from someone else's answer" do
      visit question_path(question)

      within ".answer-#{answer.id}-links" do
        expect(page).to_not have_link 'Delete link'
      end
    end
  end

  scenario 'Guest tries to delete a question link' do
    visit question_path(question)

    within ".question-links" do
      expect(page).to_not have_link 'Delete link'
    end
  end

  scenario 'Guest tries to delete an answer link' do
    visit question_path(question)

    within ".answer-#{answer.id}-links" do
      expect(page).to_not have_link 'Delete link'
    end
  end
end
