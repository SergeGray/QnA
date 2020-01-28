require 'rails_helper'

feature 'User can view a question', %q(
  In order to see more information about a resource I'm interested in
  As any user
  I want to be able to view that resource's links
) do
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:question_link) { create(:link, linkable: question) }
  given!(:answer_link) { create(:link, :yandex, linkable: answer) }
  given!(:gist) { create(:link, :gist, linkable: question) }

  before { visit question_path(question) }

  scenario 'User tries to view links' do
    expect(page).to have_link question_link.name, href: question_link.url

    within '.answers' do
      expect(page).to have_link answer_link.name, href: answer_link.url
    end
  end

  scenario 'User tries to view a gist', js: true do
    within_frame(0) do
      expect(page).to have_content 'first_file.txt'
      expect(page).to have_content 'second_file.txt.erb'
    end
  end
end
