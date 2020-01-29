require 'rails_helper'

feature 'User can select best answer', %q(
  In order to award helpful users
  As an author of the question
  I want to be able to select the best answer for that question
) do
  scenario 'Guest tries to select best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Select as best'
  end

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user', js: true do
    background { sign_in(user) }

    describe 'owns the question' do
      given!(:question) { create(:question, user: user) }
      given!(:answer) { create(:answer, question: question) }

      scenario 'tries to select the best answer for the first time' do
        visit question_path(question)

        expect(page).to_not have_content 'Best answer'

        click_link 'Select as best'

        expect(page).to have_content 'Best answer'
        expect(page).to have_content 'Answer successfully set as best'
      end

      describe 'with an award' do
        given!(:user2) { create(:user) }
        given!(:award) { create(:award, question: question) }
        given!(:answer) { create(:answer, question: question, user: user2) }

        scenario 'tries to select best answer' do
          visit question_path(question)

          using_session(user2) do
            sign_in(user2)
            click_link 'View awards'

            expect(page).to_not have_content award.title
            expect(page).to_not have_selector("#award-#{Award.last.id}")
          end

          click_link 'Select as best'
          click_link 'View awards'

          expect(page).to_not have_content award.title
   
          using_session(user2) do
            click_link 'View awards'

            expect(page).to have_content award.title
            expect(page.find("#award-#{Award.last.id}")['src'])
              .to have_content award.image.filename.to_s
          end
        end
      end

      describe 'with an existing best answer' do
        given!(:answer2) do
          create(:answer, :new, question: question, best: true)
        end

        background { visit question_path(question) }

        scenario 'tries to select another best answer' do
          expect(page.text.index(answer.body))
            .to be > page.text.index(answer2.body)

          within(".answer-#{answer2.id}") do
            expect(page).to have_content 'Best answer'
          end

          within(".answer-#{answer.id}") do
            click_link 'Select as best'

            expect(page).to have_content 'Best answer'
          end

          within(".answer-#{answer2.id}") do
            expect(page).to_not have_content 'Best answer'
          end

          expect(page).to have_content 'Answer successfully set as best'
          expect(page.text.index(answer.body))
            .to be < page.text.index(answer2.body)
        end

        scenario 'tries to select the same best answer' do
          within(".answer-#{answer2.id}") do
            expect(page).to have_content 'Best answer'
            expect(page).to_not have_link 'Select as best'
          end
        end
      end
    end

    scenario "tries to select best answer on somebody else's question" do
      visit question_path(question)

      expect(page).to_not have_link 'Select as best'
    end
  end
end
