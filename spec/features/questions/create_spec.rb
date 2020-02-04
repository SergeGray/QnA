require 'rails_helper'

feature 'User can create question', %q(
  In order to get answer from the community
  As an authenticated user
  I want to be able to ask a question
) do
  given(:user) { create(:user) }
  given(:link) { 'http://google.com' }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit questions_path
      click_link 'Ask a question'
    end

    scenario 'tries to create a question' do
      expect(page).to_not have_content 'How do I do this'
      expect(page).to_not have_content 'Help'

      fill_in 'Title', with: 'How do I do this'
      fill_in 'Body', with: 'Help'
      click_button 'Submit'

      expect(page).to have_content 'Your question was successfully created.'
      expect(page).to have_content 'How do I do this'
      expect(page).to have_content 'Help'
    end

    scenario 'tries to create a question with errors' do
      click_button 'Submit'

      expect(page).to have_content "Title can't be blank"
    end

    describe 'when creating a question with valid attributes' do
      before do
        fill_in 'Title', with: 'How do I do this'
        fill_in 'Body', with: 'Help'
      end

      scenario 'tries to attach files' do
        attach_file 'File', [
          "#{Rails.root}/spec/rails_helper.rb",
          "#{Rails.root}/spec/spec_helper.rb"
        ]
        click_button 'Submit'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

      scenario 'tries to attach a link', js: true do
        click_link 'add link'

        fill_in 'Name', with: 'Example link'
        fill_in 'Url', with: link

        within_window open_new_window do
          visit questions_path
          expect(page).to_not have_link 'Example link', href: link
          expect(page).to_not have_link 'Show'
        end

        click_button 'Submit'

        expect(page).to have_link 'Example link', href: link
      end

      scenario 'tries to attach an invalid link', js: true do
        click_link 'add link'

        fill_in 'Name', with: 'Example link'
        fill_in 'Url', with: 'invalid format'

        click_button 'Submit'

        expect(page).to_not have_link 'Example link'
        expect(page).to have_content 'Links url is invalid'
      end

      scenario 'tries to create a reward', js: true do
        fill_in 'question[award_attributes][title]', with: 'Example title'
        attach_file 'Image', "#{Rails.root}/spec/fixtures/files/image.png"

        within_window open_new_window do
          visit questions_path
          expect(page).to_not have_content 'Example title'
          expect(page).to_not have_link 'Show'
        end

        click_button 'Submit'

        expect(page).to have_content 'Example title'
        expect(page.find("#award-#{Award.last.id}")['src'])
          .to have_content 'image.png'
      end

      scenario 'tries to create a reward with invalid parameters' do
        fill_in 'question[award_attributes][title]', with: 'Example title'

        click_button 'Submit'

        expect(page).to_not have_content 'Example title'
        expect(page).to have_content "Award image can't be blank"
      end
    end
  end

  context 'In multiple sessions', js: true do
    scenario "new question appears on another user's page" do
      using_session('guest') do
        visit questions_path
        expect(page).to_not have_content 'How do I do this'
        expect(page).to_not have_content 'Help'
      end

      using_session('user') do
        sign_in(user)
        visit new_question_path

        fill_in 'Title', with: 'How do I do this'
        fill_in 'Body', with: 'Help'
        click_button 'Submit'

        expect(page).to have_content 'How do I do this', count: 1
        expect(page).to have_content 'Help', count: 1
      end

      using_session('guest') do
        expect(page).to have_content 'How do I do this'
        expect(page).to have_content 'Help'
      end
    end
  end

  scenario 'Unauthenticated user tries to create a question' do
    visit questions_path

    expect(page).to_not have_link 'Ask a question'
  end
end
