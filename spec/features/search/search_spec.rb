require 'sphinx_helper'

feature 'User can search resources', %q(
  In order to find existing information on my problem
  As any user
  I want to be able to search resources
), sphinx: true, js: true do
  given!(:ruby_question) { create(:question, title: 'How do I install Ruby?') }
  given!(:other_question) { create(:question, title: 'Help me!') }
  given!(:ruby_answer) { create(:answer, body: 'Use rvm to install ruby') }
  given!(:other_answer) { create(:answer, body: 'Just google it lol') }
  given!(:ruby_comment) { create(:comment, body: "That's ruby for ya") }
  given!(:other_comment) { create(:comment, body: 'Good question') }
  given!(:ruby_user) { create(:user, email: 'ruby.user@gmail.com') }
  given!(:other_user) { create(:user) }

  given!(:ruby_attributes) do
    {
      'Question' => ruby_question.title,
      'Answer' => ruby_answer.body,
      'Comment' => ruby_comment.body,
      'User' => ruby_user.email
    }
  end

  given!(:other_attributes) do
    [
      other_question.title,
      other_answer.body,
      other_comment.body,
      other_user.email
    ]
  end


  before do
    visit root_path
    fill_in 'query', with: 'ruby'
  end

  after do   
    other_attributes.each do |attribute|
      expect(page).to_not have_content attribute
    end
  end


  scenario 'User tries to do a global search' do
    ThinkingSphinx::Test.run do
      click_button 'Search'
      
      ruby_attributes.each do |_, attribute|
        expect(page).to have_content attribute
      end
    end
  end
  
  SearchService::RESOURCES.each do |resource|
    scenario "User tries to do a #{resource} search" do
      ThinkingSphinx::Test.run do
        select resource, from: 'resource'
        click_button 'Search'

        expect(page).to have_content ruby_attributes[resource]

        ruby_attributes.except(resource).each do |_, attribute|
          expect(page).to_not have_content attribute
        end
      end
    end
  end
end
