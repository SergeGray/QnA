require 'rails_helper'

feature 'User can sign up', %q(
  In order to be able to ask questions
  As an unauthenticated user
  I want to be able to sign up
) do
  background { visit new_user_registration_path }

  scenario 'User tries to sign up' do
    fill_in 'Email', with: 'email@example.com'
    fill_in 'Password', with: '123123'
    fill_in 'Password confirmation', with: '123123'
    click_button 'Sign up'

    expect(page).to have_content 'Welcome!'
  end

  scenario 'User tries to sign up with errors' do
    click_button 'Sign up'

    expect(page).to have_content "Email can't be blank"
  end

  scenario 'User tries to sign up with existing Email' do
    user = create(:user)

    fill_in 'Email', with: user.email
    fill_in 'Password', with: '123123'
    fill_in 'Password confirmation', with: '123123'
    click_button 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end
end
