require 'rails_helper'

feature 'User can vote on a question', %q(
  In order to express their opinion on a question
  As an authenticated user
  I want to be able to vote on a question
) do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background { sign_in(user) }
    
    describe 'does not own the question' do
      background { visit question_path(question) }

      scenario 'tries to upvote a question' do
        expect(page).to have_content 'Score: 0'

        click_link 'Upvote'

        expect(page).to have_content 'Score: 1'
      end

      scenario 'tries to downvote a question'

      scenario 'tries to cancel their vote'

      scenario 'tries to change their vote to the opposite'

      scenario 'tries to vote more than once'
    end

    describe 'owns the question' do
      given!(:question) { create(:question, user: user) }

      scenario 'tries to vote on it'
    end
  end

  scenario 'Guest tries to vote on a question'
end
