require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:api_path) { '/api/v1/profiles' }

  describe 'GET /api/v1/profiles/me' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:path) { "#{api_path}/me" }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:user_response) { json['user'] }

      before do
        get "#{api_path}/me",
            params: { access_token: access_token.token },
            headers: headers
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(user_response[attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(user_response).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:path) { api_path }
    end
    
    context 'authorized' do
      let!(:me) { create(:user) }
      let!(:other_users) { create_list(:user, 4) }
      let(:other_user) { other_users.first }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:user_response) { json['users'].first }

      before do
        get api_path,
            params: { access_token: access_token.token },
            headers: headers
      end

      it_behaves_like 'API get many' do
        let!(:resource_list) { other_users }
        let(:resources) { json['users'] }
        let(:public_fields) { %w[id email admin created_at updated_at] }
        let(:private_fields) { %w[password encrypted_password] }
      end

      it 'does not return me' do
        json['users'].each do |user|
          expect(user['id']).to_not eq me.id
        end
      end
    end
  end
end
