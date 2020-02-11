require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  let(:email) { 'email@example.com' }
  let(:mock_auth) do
    mock_auth_hash(provider, email: email)
  end

  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @request.env['omniauth.auth'] = mock_auth
  end

  describe 'GET #github' do
    let(:provider) { :github }

    context 'user exists' do
      let!(:user) { create(:user, email: email) }

      it 'logs in' do
        get :github
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        get :github
        expect(response).to redirect_to root_path
      end

      it 'does not create new user' do
        expect { get :github }.to_not change(User, :count)
      end
    end

    context 'user does not exist' do
      it 'creates a new user' do
        expect { get :github }.to change(User, :count).by 1
      end

      it 'logs in the new user' do
        get :github
        expect(assigns(:user)).to eq(subject.current_user)
      end

      it 'redirects to root path' do
        get :github
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'GET #vkontakte' do
    let(:provider) { :vkontakte }

    context 'user exists' do
      let!(:user) { create(:user, email: email) }

      it 'logs in' do
        get :vkontakte
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        get :vkontakte
        expect(response).to redirect_to root_path
      end

      it 'does not create new user' do
        expect { get :vkontakte }.to_not change(User, :count)
      end
    end

    context 'user does not exist' do
      it 'creates a new user' do
        expect { get :vkontakte }.to change(User, :count).by 1
      end

      it 'logs in the new user' do
        get :vkontakte
        expect(assigns(:user)).to eq(subject.current_user)
      end

      it 'redirects to root path' do
        get :vkontakte
        expect(response).to redirect_to root_path
      end
    end
  end
end
