require 'rails_helper'

describe 'Questions API', type: :request do
  let(:api_path) { '/api/v1/questions' }

  describe 'GET index' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:path) { api_path }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let!(:answers) { create_list(:answer, 3, question: question) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }

      before do
        get api_path, 
            params: { access_token: access_token.token },
            headers: headers
      end

      it_behaves_like 'API get many' do
        let!(:resource_list) { questions }
        let(:resources) { json['questions'] }
        let(:public_fields) { %w[id title body created_at updated_at] }
        let(:private_fields) { [] }
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains a short title' do
        expect(question_response['short_title'])
          .to eq question.title.truncate(20)
      end

      describe 'answer' do
        it_behaves_like 'API get many' do
          let!(:resource_list) { answers }
          let(:resources) { json['questions'].first['answers'] }
          let(:public_fields) { %w[id body created_at updated_at] }
          let(:private_fields) { [] }
        end
      end
    end
  end
end
