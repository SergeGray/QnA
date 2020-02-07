require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  let(:email) { 'email@example.com' }
  let(:mock_auth) do
    OmniAuth.config.add_mock(
      :github,
      provider: 'github',
      uid: '123456',
      info: { email: email }
    )
  end

  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @request.env['omniauth.auth'] = mock_auth
  end

  describe 'GET #github' do
    context 'user exists' do
      let!(:user) { create(:user, email: email) }

      before { get :github }

      it 'logs in' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      it 'creates a new user' do
        expect{ get :github }.to change(User, :count).by 1
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
end
