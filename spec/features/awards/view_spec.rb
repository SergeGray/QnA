require 'rails_helper'

feature 'User can view his awards', %q(
  In order to feel sense of pride and accomplishment
  As an authenticated user
  I want to be able to view my awards
) do
  given!(:user) { create(:user) }
  given!(:user2) { create(:user2) }
  given!(:award) { create(:award, user: user) }

  scenario 'Authenticated user tries to see his awards' do
    sign_in(user)

    click_link 'View awards'

    expect(page).to have_content award.title
    expect(page.find("#award-#{Award.last.id}")['src'])
      .to have_content award.image.filename.to_s
  end

  scenario "Authenticated user tries to see someone else's awards" do
    sign_in(user2)

    click_link 'View awards'

    expect(page).to_not have_content award.title
    expect(page.find("#award-#{Award.last.id}")['src'])
      .to_not have_content award.image.filename.to_s 
  end

  scenario 'Guest tries to see awards' do
    expect(page).to_not have_link 'View awards'
  end
end
