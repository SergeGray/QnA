require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from the community
  As an authenticated user
  I want to be able to ask a question
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user tries to create a question' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'

    visit questions_path
    click_link 'Ask a question'

    fill_in 'Title', with: 'How do I do this'
    fill_in 'Body', with: 'Help'
    click_button 'Submit'

    expect(page).to have_content 'Your question was successfully created.'
    expect(page).to have_content 'How do I do this'
    expect(page).to have_content 'Help'
  end

  scenario 'Authenticated user tries to create a question with errors' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'

    visit questions_path
    click_link 'Ask a question'

    click_button 'Submit'

    expect(page).to have_content "Title can't be blank"
  end

  scenario 'Unauthenticated user tries to create a question' do
    visit questions_path
    click_link 'Ask a question'

    expect(page).to have_content 'You need to sign in or sign up'
  end
end
