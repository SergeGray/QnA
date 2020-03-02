require 'rails_helper'

feature 'User can subscribe to a question', %q(
  In order to stop getting notified about answers to a question
  As an authenticated user
  I want to be able to unsubscribe from a question
) do
  given(:question) { create(:question) }

  context 'Authenticated user', js: true do
    given(:user) { create(:user) }
    given!(:subscription) do
      create(:subscription, user: user, question: question)
    end

    before { sign_in(user) }

    scenario 'tries to unsubscribe from a question' do
      visit question_path(question)
      expect(page).to_not have_link 'Subscribe'
      click_link 'Unsubscribe'

      expect(page).to have_content(
        'You have successfully unsubscribed from the question.'
      )

      expect(page).to have_link 'Subscribe'
      expect(page).to_not have_link 'Unsubscribe'
    end
  end

  scenario 'Unauthenticated user tries to unsubscribe from a question' do
    visit question_path(question)

    expect(page).to_not have_link 'Unsubscribe'
  end
end
