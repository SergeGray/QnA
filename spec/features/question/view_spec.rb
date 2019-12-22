require 'rails_helper'

feature 'User can view a question', %q{
  In order to see more information about a question I'm interested in
  As any user
  I want to be able to view a question with answers to it
} do

  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'Any user can view a question with answers to it' do
    visit questions_path
    click_link 'Show'
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answer.body
  end
end
