require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before { @request.env['devise.mapping'] = Devise.mappings[:user] }

  describe 'GET #github' do
    let(:oauth_data) do
      OmniAuth::AuthHash.new(
        provider: 'github',
        uid: '123',
        info: { email: 'new_user@example.com' }
      )
    end

    before do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env)
        .to receive(:[])
        .with('omniauth.auth')
        .and_return(oauth_data)
    end

    context 'user exists' do
      let!(:user) { create(:user, email: oauth_data.info[:email]) }

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
