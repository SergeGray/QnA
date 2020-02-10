require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  describe 'POST #create' do
    context 'with omniauth hash in session' do
      let(:session_hash) do
        { omniauth: { 'provider' => 'github', 'uid' => '123' } }
      end

      it 'creates authorizations for user' do
        expect do
          post :create,
               params: { user: attributes_for(:user) },
               session: session_hash
        end.to change(Authorization, :count).by 1
      end

      it 'calls parent method' do
        expect(subject).to receive(:expire_data_after_sign_in!)
        post :create,
             params: { user: attributes_for(:user) },
             session: session_hash
      end
    end

    it 'calls parent method' do
      expect(subject).to receive(:sign_up)
      post :create, params: { user: attributes_for(:user) }
    end
  end
end
