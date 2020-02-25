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
  
  describe 'GET /api/v1/answers/:id' do
    let!(:answer) { create(:answer) }
    let(:answer_path) { "#{api_path}/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:path) { answer_path }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answer'] }

      it_behaves_like 'API get one' do
        let(:resource) { answer }
        let(:resource_response) { answer_response }

        before do
          get answer_path, 
              params: { access_token: access_token.token },
              headers: headers
        end
      end

      context 'with comments' do
        let!(:comments) { create_list(:comment, 3, commentable: answer) }

        before do
          get answer_path, 
              params: { access_token: access_token.token },
              headers: headers
        end

        it_behaves_like 'API get many' do
          let!(:resource_list) { comments }
          let(:resource_json) { answer_response['comments'] }
          let(:public_fields) { %w[id body user_id created_at updated_at] }
        end
      end

      context 'with attached files' do
        let(:resource_list) { answer.files }
        let(:resource_json) { answer_response['files'] }
        let(:public_fields) { %w[id filename] }

        before do
          3.times { answer.files.attach(create_file_blob) }

          get answer_path, 
              params: { access_token: access_token.token },
              headers: headers
        end

        it_behaves_like 'API get many'
        
        it_behaves_like 'API get file url'
      end

      context 'with attached links' do
        let!(:links) { create_list(:link, 3, linkable: answer) }

        before do
          get answer_path, 
              params: { access_token: access_token.token },
              headers: headers
        end

        it_behaves_like 'API get many' do
          let!(:resource_list) { links }
          let(:resource_json) { json['answer']['links'] }
          let(:public_fields) { %w[id name url created_at updated_at] }
        end
      end
    end
  end
end
