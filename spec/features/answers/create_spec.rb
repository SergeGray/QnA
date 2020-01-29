require 'rails_helper'

feature 'User can answer a question', %q(
  In order to help people with their problems
  As an authenticated user
  I want to be able to answer a question
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:link) { 'http://example.com' }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries to answer a question' do
      expect(page).to_not have_content 'Just use puts.'

      fill_in 'Body', with: 'Just use puts.'
      click_button 'Answer'

      expect(page).to have_content 'Your answer was successfully created.'
      expect(page).to have_content 'Just use puts.'
    end

    scenario 'tries to answer a question with errors' do
      click_button 'Answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'tries to answer with attached files' do
      fill_in 'Body', with: 'Just use puts.'

      attach_file 'File', [
        "#{Rails.root}/spec/rails_helper.rb",
        "#{Rails.root}/spec/spec_helper.rb"
      ]
      click_button 'Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'tries to answer with an attached link' do
      fill_in 'Body', with: 'Question body'

      click_link 'add link'

      fill_in 'Name', with: 'Example link'
      fill_in 'Url', with: link

      within_window open_new_window do
        visit question_path(question)
        expect(page).to_not have_link 'Example link', href: link
      end

      click_button 'Answer'

      within('.answers') do
        expect(page).to have_link 'Example link', href: link
      end
    end

    scenario 'tries to answer with an invalid link' do
      fill_in 'Body', with: 'Question body'

      click_link 'add link'

      fill_in 'Name', with: 'Example link'
      fill_in 'Url', with: 'invalid format'

      click_button 'Answer'

      within('.answers') do
        expect(page).to_not have_link 'Example link'
      end

      expect(page).to have_content "Links url is invalid"
    end
  end

  scenario 'Unauthenticated user tries to answer a question' do
    visit question_path(question)

    expect(page).to_not have_button 'Answer'
  end
end
