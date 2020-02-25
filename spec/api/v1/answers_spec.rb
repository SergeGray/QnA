require 'rails_helper'

describe 'Answers API', type: :request do
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

      it_behaves_like 'Successful response'

      it_behaves_like 'API get many' do
        let!(:resource_list) { answers }
        let(:resource_json) { json['answers'] }
      end
    end
  end
  
  describe 'GET /api/v1/answers/:id' do
    let!(:answer) { create(:answer) }
    let!(:comments) { create_list(:comment, 3, commentable: answer) }
    let!(:links) { create_list(:link, 3, linkable: answer) }

    before { 3.times { answer.files.attach(create_file_blob) } }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:path) { "#{api_path}/answers/#{answer.id}" }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answer'] }

      before do
        get "#{api_path}/answers/#{answer.id}", 
            params: { access_token: access_token.token },
            headers: headers
      end

      it_behaves_like 'Successful response'

      it_behaves_like 'API get one' do
        let(:resource) { answer }
        let(:resource_response) { answer_response }
      end
      
      describe 'returns attached user' do
        it_behaves_like 'API get one' do
          let(:resource) {  answer.user }
          let(:resource_response) { answer_response['user'] }
          let(:public_fields) { %w[id email admin created_at updated_at] }
          let(:private_fields) { %w[password encrypted_password] }
        end
      end

      describe 'returns attached comments' do
        it_behaves_like 'API get many' do
          let(:resource_list) { comments }
          let(:resource_json) { answer_response['comments'] }
          let(:public_fields) { %w[id body user_id created_at updated_at] }
        end
      end

      describe 'returns attached files' do
        let(:resource_list) { answer.files }
        let(:resource_json) { answer_response['files'] }
        let(:public_fields) { %w[id filename] }

        it_behaves_like 'API get many'

        it_behaves_like 'API get file url'
      end

      describe 'returns attached links' do
        it_behaves_like 'API get many' do
          let!(:resource_list) { links }
          let(:resource_json) { answer_response['links'] }
          let(:public_fields) { %w[id name url created_at updated_at] }
        end
      end
    end
  end
end
