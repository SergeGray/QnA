require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:api_path) { '/api/v1/profiles' }
  let(:public_fields) { %w[id email admin created_at updated_at] }
  let(:private_fields) { %w[password encrypted_password] }

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

      it_behaves_like 'Successful response'

      it_behaves_like 'API get one' do
        let(:resource) { me }
        let(:resource_response) { user_response }
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
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:users_response) { json['users'] }

      before do
        get api_path,
            params: { access_token: access_token.token },
            headers: headers
      end

      it_behaves_like 'Successful response'

      it_behaves_like 'API get many' do
        let!(:resource_list) { other_users }
        let(:resource_json) { users_response }
      end

      it 'does not return me' do
        users_response.each do |user|
          expect(user['id']).to_not eq me.id
        end
      end
    end
  end
end
