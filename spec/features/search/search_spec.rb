require 'sphinx_helper'

feature 'User can search resources', %q(
  In order to find existing information on my problem
  As any user
  I want to be able to search resources
) do
  given!(:ruby_question) { create(:question, title: 'How do I install Ruby?') }
  given!(:other_question) { create(:question, title: 'Help me!') }
  given!(:ruby_answer) { create(:answer, body: 'Use rvm to install ruby') }
  given!(:other_answer) { create(:answer, body: 'Just google it lol') }
  given!(:ruby_comment) { create(:comment, body: "That's ruby for ya") }
  given!(:other_comment) { create(:comment, body: 'Good question') }
  given!(:ruby_user) { create(:user, email: 'ruby.user@gmail.com') }
  given!(:other_user) { create(:user) }

  scenario 'User tries to do a global search', sphinx: true, js: true do
    visit root_path

    ThinkingSphinx::Test.run do
      fill_in 'query', with: 'ruby'
      click_button 'Search'

      expect(page).to have_content ruby_question.title
      expect(page).to have_content ruby_answer.body
      expect(page).to have_content ruby_comment.body
      expect(page).to have_content ruby_user.email
      expect(page).to_not have_content other_question.title
      expect(page).to_not have_content other_answer.body
      expect(page).to_not have_content other_comment.body
      expect(page).to_not have_content other_user.email
    end
  end
end
