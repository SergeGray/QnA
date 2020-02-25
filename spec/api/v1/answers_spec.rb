require 'rails_helper'

describe 'Answerss API', type: :request do
  let(:api_path) { '/api/v1/' }
  let(:public_fields) { %w[id body created_at updated_at] }
  let(:private_fields) { [] }
  let(:question) { create(:question) }

  describe 'GET /api/v1/questions/:id/answers' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:path) { "#{api_path}/questions/#{question.id}/answers" }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 2, question: question) }

      before do
        get "#{api_path}/questions/#{question.id}/answers", 
            params: { access_token: access_token.token },
            headers: headers
      end

      it_behaves_like 'API get many' do
        let!(:resource_list) { answers }
        let(:resource_json) { json['answers'] }
      end
    end
  end
end
