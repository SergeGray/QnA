require 'rails_helper'

feature 'User can vote on an answer', %q(
  In order to express their opinion on an answer
  As an authenticated user
  I want to be able to vote on an answer
) do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user', js: true do
    background { sign_in(user) }

    context 'does not own the answer' do
      background { visit question_path(question) }

      scenario 'tries to upvote a question' do
        within('.answers') do
          expect(page).to have_content 'Score: 0'

          click_link 'Upvote'

          expect(page).to have_content 'Score: 1'
        end
      end

      scenario 'tries to downvote an answer' do
        within('.answers') do
          expect(page).to have_content 'Score: 0'

          click_link 'Downvote'

          expect(page).to have_content 'Score: -1'
        end
      end

      scenario 'tries to change their vote to the opposite' do
        within('.answers') do
          expect(page).to have_content 'Score: 0'

          click_link 'Downvote'

          expect(page).to have_content 'Score: -1'

          click_link 'Upvote'

          expect(page).to have_content 'Score: 1'
        end
      end

      scenario 'tries to vote more than once' do
        within('.answers') do
          click_link 'Downvote'

          expect(page).to_not have_link 'Downvote'
        end
      end

      scenario 'tries to cancel their vote' do
        within('.answers') do
          expect(page).to_not have_link 'Cancel vote'

          click_link 'Upvote'

          expect(page).to have_link 'Cancel vote'

          click_link 'Cancel vote'

          expect(page).to_not have_link 'Cancel vote'

          expect(page).to have_link 'Upvote'
          expect(page).to have_link 'Downvote'
          expect(page).to have_content 'Score: 0'
        end
      end

      context 'with another answer' do
        given!(:answer2) { create(:answer, question: question) }

        scenario 'tries to vote for one of them' do
          visit question_path(question)

          within(".answer-#{answer2.id}") do
            expect(page).to have_content 'Score: 0'
          end

          within(".answer-#{answer.id}") do
            click_link 'Upvote'
          end

          within(".answer-#{answer2.id}") do
            expect(page).to have_content 'Score: 0'
          end
        end
      end
    end

    context 'owns the answer' do
      given!(:answer) { create(:answer, question: question, user: user) }

      scenario 'tries to vote on it' do
        visit question_path(question)

        within('.answers') do
          expect(page).to_not have_link 'Upvote'
          expect(page).to_not have_link 'Cancel vote'
          expect(page).to_not have_link 'Downvote'
        end
      end
    end
  end

  scenario 'Guest tries to vote on an answer' do
    visit question_path(question)

    within('.answers') do
      expect(page).to_not have_link 'Upvote'
      expect(page).to_not have_link 'Cancel vote'
      expect(page).to_not have_link 'Downvote'
    end
  end
end
