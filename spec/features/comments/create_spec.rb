require 'rails_helper'

feature 'User can create a comment', %q(
  In order to point out any mistakes and/or ask for clarification
  As an authenticated user
  I want to be able to post a comment on a resource
) do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries to create a question comment' do
      expect(page).to_not have_content 'Can you post a code snippet?'

      within(".question-#{question.id}-comments") do
        click_link 'New comment'

        fill_in 'comment[body]', with: 'Can you post a code snippet?'
        click_button 'Comment'
      end

      expect(page).to have_content 'Your comment was successfully created.'
      expect(page).to have_content 'Can you post a code snippet?'
    end

    scenario 'tries to create an answer comment' do
      expect(page).to_not have_content 'Can you post a code snippet?'

      within(".answer-#{answer.id}-comments") do
        click_link 'New comment'

        fill_in 'comment[body]', with: 'Can you post a code snippet?'
        click_button 'Comment'
      end

      expect(page).to have_content 'Your comment was successfully created.'
      expect(page).to have_content 'Can you post a code snippet?'
    end

    scenario 'tries to create a question comment with errors' do
      within(".question-#{question.id}-comments") do
        click_link 'New comment'

        click_button 'Comment'
      end

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'tries to create an answer comment with errors' do
      within(".answer-#{answer.id}-comments") do
        click_link 'New comment'

        click_button 'Comment'
      end

      expect(page).to have_content "Body can't be blank"
    end
  end

  context 'In multiple sessions', js: true do
    scenario "new question comment appears on another user's page" do
      using_session('guest') do
        visit question_path(question)

        expect(page).to_not have_content 'Good question'
      end

      using_session('user') do
        sign_in(user)
        visit question_path(question)
        
        within(".question-#{question.id}-comments") do
          click_link 'New comment'

          fill_in 'comment[body]', with: 'Good question'
          click_button 'Comment'
        end
      end

      using_session('guest') do
        within(".question-#{question.id}-comments") do
          expect(page).to have_content 'Good question'
        end
      end
    end

    scenario "new answer comment appears on another user's page" do
      using_session('guest') do
        visit question_path(question)
        
        expect(page).to_not have_content 'Good answer'
      end

      using_session('user') do
        sign_in(user)
        visit question_path(question)
        
        within(".answer-#{answer.id}-comments") do
          click_link 'New comment'

          fill_in 'comment[body]', with: 'Good answer'
          click_button 'Comment'
        end
      end

      using_session('guest') do

        within(".answer-#{answer.id}-comments") do
          expect(page).to have_content 'Good answer'
        end
      end
    end
  end

  scenario 'Unauthenticated user tries to create a question comment' do
    visit question_path(question)

    within(".question-#{question.id}-comments") do
      expect(page).to_not have_link 'New comment'
    end
  end
    

  scenario 'Unauthenticated user tries to create a question comment' do
    visit question_path(question)

    within(".answer-#{answer.id}-comments") do
      expect(page).to_not have_link 'New comment'
    end
  end
end
