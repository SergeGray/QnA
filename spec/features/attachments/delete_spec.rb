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
    question.files.attach(
      io: File.open("#{Rails.root}/spec/spec_helper.rb"),
      filename: 'spec_helper.rb'
    )
    answer.files.attach(
      io: File.open("#{Rails.root}/spec/rails_helper.rb"),
      filename: 'rails_helper.rb'
    )
  end

  describe 'Authorized user', js: true do
    background { sign_in(user) }

    describe 'owns a question' do
      given(:question) { create(:question, user: user) }

      scenario 'tries to delete it' do
        visit question_path(question)

        within ".question-#{question.id}-files" do
          expect(page).to have_link 'spec_helper.rb'

          click_link 'Delete file'

          expect(page).to_not have_link 'spec_helper.rb'
        end
      end
    end

    describe 'owns an answer' do
      given(:answer) { create(:answer, question: question, user: user) }

      scenario 'tries to delete it' do
        visit question_path(question)

        within ".answer-#{answer.id}-files" do
          expect(page).to have_link 'rails_helper.rb'

          click_link 'Delete file'

          expect(page).to_not have_link 'rails_helper.rb'
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

    within ".question-#{question.id}-files" do
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
