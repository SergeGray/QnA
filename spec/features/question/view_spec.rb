require 'rails_helper'

feature 'User can view a question', %q(
  In order to see more information about a question I'm interested in
  As any user
  I want to be able to view a question with answers to it
) do
  given!(:question) { create(:question) }
  given!(:answer1) { create(:answer, question: question) }
  given!(:answer2) { create(:answer, :new, question: question) }
  given!(:answer3) { create(:answer, body: 'This answer is not related') }

  scenario 'User tries to view a question' do
    visit questions_path
    click_link('Show', match: :first)
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answer1.body
    expect(page).to have_content answer2.body
    expect(page).to_not have_content answer3.body
  end
end
