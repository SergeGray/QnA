require 'rails_helper'

describe 'Questions API', type: :request do
  let(:api_path) { '/api/v1/questions' }
  let(:public_fields) { %w[id title body created_at updated_at] }
  let(:private_fields) { [] }

  describe 'GET /api/v1/questions' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:path) { api_path }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }

      before do
        get api_path, 
            params: { access_token: access_token.token },
            headers: headers
      end

      it_behaves_like 'API get many' do
        let!(:resource_list) { questions }
        let(:resource_json) { json['questions'] }
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let!(:question) { create(:question) }
    let(:question_path) { "#{api_path}/#{question.id}" }
    let!(:answers) { create_list(:answer, 3, question: question) }
    let!(:comments) { create_list(:comment, 3, commentable: question) }
    let!(:links) { create_list(:link, 3, linkable: question) }

    before { 3.times { question.files.attach(create_file_blob) } }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:path) { question_path }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }

      before do
        get question_path, 
            params: { access_token: access_token.token },
            headers: headers
      end

      it_behaves_like 'API get one' do
        let(:resource) { question }
        let(:resource_response) { question_response }
      end

      describe 'returns attached user' do
        it_behaves_like 'API get one' do
          let(:resource) {  question.user }
          let(:resource_response) { question_response['user'] }
          let(:public_fields) { %w[id email admin created_at updated_at] }
          let(:private_fields) { %w[password encrypted_password] }
        end
      end

      describe 'returns attached answers' do
        it_behaves_like 'API get many' do
          let(:resource_list) { answers }
          let(:resource_json) { question_response['answers'] }
          let(:public_fields) { %w[id body user_id created_at updated_at] }
        end
      end

      describe 'returns attached comments' do
        it_behaves_like 'API get many' do
          let(:resource_list) { comments }
          let(:resource_json) { question_response['comments'] }
          let(:public_fields) { %w[id body user_id created_at updated_at] }
        end
      end

      describe 'returns attached files' do
        let(:resource_list) { question.files }
        let(:resource_json) { question_response['files'] }
        let(:public_fields) { %w[id filename] }

        it_behaves_like 'API get many'

        it_behaves_like 'API get file url'
      end

      describe 'returns attached links' do
        it_behaves_like 'API get many' do
          let!(:resource_list) { links }
          let(:resource_json) { question_response['links'] }
          let(:public_fields) { %w[id name url created_at updated_at] }
        end
      end
    end
  end
end
