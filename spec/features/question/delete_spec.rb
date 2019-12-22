require 'rails_helper'

feature 'User can delete their question', %q{
  In order to remove bad or outdated questions
  As an authenticated user
  I want to be able to delete my question
} do

  given(:user) { create(:user) }
  
  background { sign_in(user) }


  scenario 'User tries to delete their question' do
    question = create(:question, user: user)

    visit questions_path
    click_link 'Destroy'
        
    expect(page).to have_content(
      'Your question was successfully destroyed'
    )
    expect(page).to_not have_content(question.title)
  end

  scenario "User tries to delete somebody else's question" do
    create(:question)

    visit questions_path

    expect(page).to_not have_link('Destroy')
  end
end

