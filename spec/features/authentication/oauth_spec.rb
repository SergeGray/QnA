require 'rails_helper'

feature 'User can sign in with oauth providers', %q(
  In order to ask question
  As an unauthenticated user
  I want to be able to sign in using oauth providers
) do
  given!(:user) { create(:user) }

  describe 'Github' do
    describe 'Registered user' do
      background { mock_auth_hash(:github, email: user.email, uid: '123123') }

      scenario 'tries to sign in for the first time' do
        visit new_user_session_path
        click_link 'Sign in with GitHub'

        expect(page).to have_content(
          'Successfully authenticated from Github account'
        )
        expect(page).to have_content 'Sign out'
      end

      context 'with an authorization' do
        given!(:authorization) do
          create(
            :authorization,
            user: user,
            provider: 'github',
            uid: '123123'
          )
        end

        scenario 'tries to sign in' do
          visit new_user_session_path
          click_link 'Sign in with GitHub'

          expect(page).to have_content(
            'Successfully authenticated from Github account'
          )
          expect(page).to have_content 'Sign out'
        end
      end
    end

    scenario 'Unregistered user tries to sign in with github' do
      mock_auth_hash(:github, email: 'email@example.com')

      visit new_user_session_path
      click_link 'Sign in with GitHub'

      expect(page).to have_content(
        'Successfully authenticated from Github account'
      )
      expect(page).to have_content 'Sign out'
    end

    scenario 'provider does not give email' do
      mock_auth_hash(:github, email: nil)

      visit new_user_session_path
      click_link 'Sign in with GitHub'

      expect(page).to have_content 'Please complete registration'

      fill_in 'Email', with: 'email@example.com'
      click_button 'Sign up'

      expect(page).to have_content(
        'A message with a confirmation link has been sent '\
        'to your email address.'
      )

      open_email 'email@example.com'
      current_email.click_link 'Confirm my account'

      click_link 'Sign in with GitHub'

      expect(page).to have_content(
        'Successfully authenticated from Github account'
      )
    end

    context 'with invalid credentials' do
      background { OmniAuth.config.mock_auth[:github] = :invalid_credentials }
      scenario 'user tries to sign in' do
        visit new_user_session_path
        click_link 'Sign in with GitHub'

        expect(page).to have_content 'Could not authenticate you from GitHub'
        expect(page).to_not have_content 'Sign out'
      end
    end
  end

  describe 'VK' do
    describe 'Registered user' do
      background do
        mock_auth_hash(:vkontakte, email: user.email, uid: '123123')
      end

      scenario 'tries to sign in for the first time' do
        visit new_user_session_path
        click_link 'Sign in with Vkontakte'

        expect(page).to have_content(
          'Successfully authenticated from Vkontakte account'
        )
        expect(page).to have_content 'Sign out'
      end

      context 'with an authorization' do
        given!(:authorization) do
          create(
            :authorization,
            user: user,
            provider: 'vkontakte',
            uid: '123123'
          )
        end

        scenario 'tries to sign in' do
          visit new_user_session_path
          click_link 'Sign in with Vkontakte'

          expect(page).to have_content(
            'Successfully authenticated from Vkontakte account'
          )
          expect(page).to have_content 'Sign out'
        end
      end
    end

    scenario 'Unregistered user tries to sign in with vkontakte' do
      mock_auth_hash(:vkontakte, email: 'email@example.com')

      visit new_user_session_path
      click_link 'Sign in with Vkontakte'

      expect(page).to have_content(
        'Successfully authenticated from Vkontakte account'
      )
      expect(page).to have_content 'Sign out'
    end

    scenario 'provider does not give email' do
      mock_auth_hash(:vkontakte, email: nil)

      visit new_user_session_path
      click_link 'Sign in with Vkontakte'

      expect(page).to have_content 'Please complete registration'

      fill_in 'Email', with: 'email@example.com'
      click_button 'Sign up'

      expect(page).to have_content(
        'A message with a confirmation link has been sent '\
        'to your email address.'
      )

      open_email 'email@example.com'
      current_email.click_link 'Confirm my account'

      click_link 'Sign in with Vkontakte'

      expect(page).to have_content(
        'Successfully authenticated from Vkontakte account'
      )
    end

    context 'with invalid credentials' do
      background do
        OmniAuth.config.mock_auth[:vkontakte] = :invalid_credentials
      end

      scenario 'user tries to sign in' do
        visit new_user_session_path
        click_link 'Sign in with Vkontakte'

        expect(page).to have_content 'Could not authenticate you from Vkontakte'
        expect(page).to_not have_content 'Sign out'
      end
    end
  end
end
