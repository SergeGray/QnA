require 'rails_helper'

feature 'User can delete their attachments', %q(
  In order to prevent bad or outdated attachments from being seen
  As an author of the resource
  I want to be able to delete my attachments
) do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  background do
    question.files.attach(create_file_blob)
    answer.files.attach(create_file_blob)
  end

  describe 'Authorized user', js: true do
    background { sign_in(user) }

    describe 'owns a question' do
      given(:question) { create(:question, user: user) }

      scenario 'tries to delete it' do
        visit question_path(question)

        within ".question-files" do
          expect(page).to have_link 'image'

          click_link 'Delete file'

          expect(page).to_not have_link 'image'
        end
      end
    end

    describe 'owns an answer' do
      given(:answer) { create(:answer, question: question, user: user) }

      scenario 'tries to delete it' do
        visit question_path(question)

        within ".answer-#{answer.id}-files" do
          expect(page).to have_link 'image'

          click_link 'Delete file'

          expect(page).to_not have_link 'image'
        end
      end
    end

    scenario "tries to delete an attachment from someone else's question" do
      visit question_path(question)

      within ".answer-#{answer.id}-files" do
        expect(page).to_not have_link 'Delete file'
      end
    end

    scenario "tries to delete an attachment from someone else's answer" do
      visit question_path(question)

      within ".answer-#{answer.id}-files" do
        expect(page).to_not have_link 'Delete file'
      end
    end
  end

  scenario 'Guest tries to delete a question attachment' do
    visit question_path(question)

    within ".question-files" do
      expect(page).to_not have_link 'Delete file'
    end
  end

  scenario 'Guest tries to delete an answer attachment' do
    visit question_path(question)

    within ".answer-#{answer.id}-files" do
      expect(page).to_not have_link 'Delete file'
    end
  end
end
