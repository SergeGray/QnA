require 'rails_helper'

feature 'User can add links to question', %q(
  In order to provide additional information to my question
  As an author of the question
  I want to be able to attach links to it
) do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:link) { 'http://example.com' }

  scenario 'Guest tries to add a link'
  
  background { sign_in(user) }

  describe 'owns the question' do
    scenario 'tries to add a link to it'
  end

  scenario 'tries to add a link when creating question' do
    visit new_question_path

    fill_in 'Title', with: 'Question title'
    fill_in 'Body', with: 'Question body'

    fill_in 'Name', with: 'Example link'
    fill_in 'Url', with: link

    click_button 'Submit'

    expect(page).to have_link 'Example link', href: link
  end
end
