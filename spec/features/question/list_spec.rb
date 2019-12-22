require 'rails_helper'

feature 'User can view the list questions', %q{
  In order to find a question I am interested in
  As any user
  I want to be able to see the list of questions
} do

  given!(:question1) { create(:question) }
  given!(:question2) { create(:question, :new) }

  scenario 'User tries to view a list of all questions' do
    visit questions_path
    expect(page).to have_content question1.title
    expect(page).to have_content question2.title
  end
end
