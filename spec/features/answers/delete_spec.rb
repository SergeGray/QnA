require 'rails_helper'

feature 'User can delete their answer', %q(
  In order to prevent bad or outdated answers from being seen
  As an authenticated user
  I want to be able to delete my answer
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background { sign_in(user) }

  scenario 'User tries to delete their answer' do
    answer = create(:answer, question: question, user: user)

    visit question_path(question)
    click_link 'Destroy'

    expect(page).to have_content(
      'Your answer was successfully destroyed'
    )
    expect(page).to_not have_content(answer.body)
  end

  scenario "User tries to delete somebody else's answer" do
    answer = create(:answer, question: question)

    visit question_path(question)
    expect(page).to have_content(answer.body)
    click_link 'Destroy'

    expect(page).to have_content(
      "You can't change other people's Answer!"
    )
    expect(page).to have_content(answer.body)
  end
end
