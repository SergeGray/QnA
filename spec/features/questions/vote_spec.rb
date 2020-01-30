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

    context 'does not own the question' do
      background { visit question_path(question) }

      scenario 'tries to upvote a question' do
        expect(page).to have_content 'Score: 0'

        click_link 'Upvote'

        expect(page).to have_content 'Score: 1'
      end

      scenario 'tries to downvote a question' do
        expect(page).to have_content 'Score: 0'

        click_link 'Downvote'

        expect(page).to have_content 'Score: -1'
      end

      scenario 'tries to change their vote to the opposite' do
        expect(page).to have_content 'Score: 0'

        click_link 'Downvote'

        expect(page).to have_content 'Score: -1'

        click_link 'Upvote'

        expect(page).to have_content 'Score: 1'
      end

      scenario 'tries to vote more than once' do
        click_link 'Downvote'

        expect(page).to_not have_link 'Downvote'
      end

      scenario 'tries to cancel their vote' do
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

    context 'owns the question' do
      given!(:question) { create(:question, user: user) }

      scenario 'tries to vote on it' do
        visit question_path(question)

        expect(page).to_not have_link 'Upvote'
        expect(page).to_not have_link 'Cancel vote'
        expect(page).to_not have_link 'Downvote'
      end
    end
  end

  scenario 'Guest tries to vote on a question' do
    visit question_path(question)

    expect(page).to_not have_link 'Upvote'
    expect(page).to_not have_link 'Cancel vote'
    expect(page).to_not have_link 'Downvote'
  end
end
