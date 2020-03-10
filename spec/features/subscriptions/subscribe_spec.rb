require 'rails_helper'

feature 'User can subscribe to a question', %q(
  In order to get notified about answers to a question
  As an authenticated user
  I want to be able to subscribe to a question
) do
  given!(:question) { create(:question) }

  context 'Authenticated user', js: true do
    given(:user) { create(:user) }

    before { sign_in(user) }

    scenario 'tries to subscribe to a question' do
      visit question_path(question)
      click_link 'Subscribe'

      expect(page).to have_content(
        'You have successfully subscribed to the question.'
      )

      expect(page).to_not have_link 'Subscribe'
      expect(page).to have_link 'Unsubscribe'
    end

    scenario 'tries to create a new question' do
      visit new_question_path

      fill_in 'Title', with: 'How do I do this'
      fill_in 'Body', with: 'Help'
      click_button 'Submit'

      expect(page).to_not have_link 'Subscribe'
      expect(page).to have_link 'Unsubscribe'
    end
  end

  scenario 'Unauthenticated user tries to subscribe to a question' do
    visit question_path(question)

    expect(page).to_not have_link 'Subscribe'
  end
end
