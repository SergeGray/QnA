require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:api_path) { '/api/v1/profiles' }
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/profiles/me' do
    context 'unauthorized' do
      it 'returns 401 status of there is no access_token' do
        get "#{api_path}/me", headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "#{api_path}/me", params: { access_token: '123' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      before do
        get "#{api_path}/me",
            params: { access_token: access_token.token },
            headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json[attr]).to eq user.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end
end
