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

      it_behaves_like 'Successful response'

      it_behaves_like 'API get many' do
        let!(:resource_list) { questions }
        let(:resource_json) { json['questions'] }
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let!(:question) { create(:question) }
    let!(:answers) { create_list(:answer, 2, question: question) }
    let!(:comments) { create_list(:comment, 2, commentable: question) }
    let!(:links) { create_list(:link, 2, linkable: question) }

    before { 2.times { question.files.attach(create_file_blob) } }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:path) { "#{api_path}/#{question.id}" }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }

      before do
        get "#{api_path}/#{question.id}",
            params: { access_token: access_token.token },
            headers: headers
      end

      it_behaves_like 'Successful response'

      it_behaves_like 'API get one' do
        let(:resource) { question }
        let(:resource_response) { question_response }
      end

      describe 'returns attached user' do
        it_behaves_like 'API get one' do
          let(:resource) { question.user }
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

  describe 'POST /api/v1/questions/' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
      let(:path) { api_path }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      context 'with valid params' do
        let(:valid_params) { attributes_for(:question) }

        it 'creates a new question' do
          expect do
            post api_path,
                 params: {
                   access_token: access_token.token, question: valid_params
                 },
                 headers: headers
          end.to change(Question, :count).by 1
        end

        context 'After the action is called' do
          before do
            post api_path,
                 params: {
                   access_token: access_token.token, question: valid_params
                 },
                 headers: headers
          end

          it_behaves_like 'API get one' do
            let(:resource) { Question.order(created_at: :desc).first }
            let(:resource_response) { json['question'] }
          end

          it_behaves_like 'Successful response'
        end
      end

      context 'with invalid params' do
        let(:invalid_params) { attributes_for(:question, :invalid) }

        it 'returns error response' do
          post api_path,
               params: {
                 access_token: access_token.token, question: invalid_params
               },
               headers: headers

          expect(response).to have_http_status(422)
        end

        it 'does not create a new question' do
          expect do
            post api_path,
                 params: {
                   access_token: access_token.token, question: invalid_params
                 },
                 headers: headers
          end.to_not change(Question, :count)
        end

        it 'returns a list of errors' do
          post api_path,
               params: {
                 access_token: access_token.token, question: invalid_params
               },
               headers: headers
          expect(json['question']['errors']['title']).to eq(["can't be blank"])
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let!(:question) { create(:question) }
    let(:valid_params) { { title: "New Title" } }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
      let(:path) { "#{api_path}/#{question.id}" }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      context 'on owned question' do
        let!(:question) do
          create(:question, user_id: access_token.resource_owner_id)
        end

        context 'with valid params' do
          it 'updates the question' do
            expect do
              patch "#{api_path}/#{question.id}",
                    params: {
                      access_token: access_token.token, question: valid_params
                    },
                    headers: headers
            end.to change { question.reload.title }.to "New Title"
          end

          context 'After the action is called' do
            before do
              patch "#{api_path}/#{question.id}",
                    params: {
                      access_token: access_token.token, question: valid_params
                    },
                    headers: headers
            end

            it_behaves_like 'API get one' do
              let(:resource) { question.reload }
              let(:resource_response) { json['question'] }
            end

            it_behaves_like 'Successful response'
          end
        end

        context 'with invalid params' do
          let(:invalid_params) { { title: "" } }

          it 'returns error response' do
            patch "#{api_path}/#{question.id}",
                  params: {
                    access_token: access_token.token, question: invalid_params
                  },
                  headers: headers

            expect(response).to have_http_status(422)
          end

          it 'does not update the question' do
            expect do
              patch "#{api_path}/#{question.id}",
                    params: {
                      access_token: access_token.token, question: invalid_params
                    },
                    headers: headers
            end.to_not change { question.reload.title }
          end

          it 'returns a list of errors' do
            post api_path,
                 params: {
                   access_token: access_token.token, question: invalid_params
                 },
                 headers: headers
            expect(json['question']['errors']['title'])
              .to eq(["can't be blank"])
          end
        end
      end

      context 'on unowned question' do
        it 'returns forbidden response' do
          patch "#{api_path}/#{question.id}",
                params: {
                  access_token: access_token.token, question: valid_params
                },
                headers: headers

          expect(response).to have_http_status(403)
        end

        it 'does not update the question' do
          expect do
            patch "#{api_path}/#{question.id}",
                  params: {
                    access_token: access_token.token, question: valid_params
                  },
                  headers: headers
          end.to_not change { question.reload.title }
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let!(:question) { create(:question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
      let(:path) { "#{api_path}/#{question.id}" }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      context 'on owned question' do
        let!(:question) do
          create(:question, user_id: access_token.resource_owner_id)
        end

        it 'deletes the question' do
          expect do
            delete "#{api_path}/#{question.id}",
                   params: { access_token: access_token.token, id: question },
                   headers: headers
          end.to change(Question, :count).by(-1)
        end

        context 'After the action is called' do
          before do
            delete "#{api_path}/#{question.id}",
                   params: { access_token: access_token.token, id: question },
                   headers: headers
          end

          it_behaves_like 'API get one' do
            let(:resource) { question }
            let(:resource_response) { json['question'] }
          end

          it_behaves_like 'Successful response'
        end
      end

      context 'on unowned question' do
        it 'returns forbidden response' do
          delete "#{api_path}/#{question.id}",
                 params: { access_token: access_token.token, id: question },
                 headers: headers

          expect(response).to have_http_status(403)
        end

        it 'does not delete the question' do
          expect do
            delete "#{api_path}/#{question.id}",
                   params: { access_token: access_token.token, id: question },
                   headers: headers
          end.to_not change(Question, :count)
        end
      end
    end
  end
end
