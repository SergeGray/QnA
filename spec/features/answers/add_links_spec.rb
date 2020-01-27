require 'rails_helper'

feature 'User can add links to answer', %q(
  In order to provide additional information to my answer
  As an author of the answer
  I want to be able to attach links to it
) do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:link) { 'http://example.com' }

  scenario 'Guest tries to add a link'

  background { sign_in(user) }

  describe 'owns the answer' do
    scenario 'tries to add a link to it'
  end

  scenario 'tries to add a link when creating answer', js: true do
    visit question_path(question)

    fill_in 'Body', with: 'Question body'

    fill_in 'Name', with: 'Example link'
    fill_in 'Url', with: link

    click_button 'Answer'

    within('.answers') do
      expect(page).to have_link 'Example link', href: link
    end
  end
end
