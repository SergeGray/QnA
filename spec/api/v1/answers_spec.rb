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
          let(:resource) { answer.user }
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

  describe 'POST /api/v1/questions/:question_id/answers' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
      let(:path) { "#{api_path}/questions/#{question.id}/answers" }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      context 'with valid params' do
        let(:valid_params) { attributes_for(:answer, question: question) }

        it 'creates a new answer' do
          expect do
            post "#{api_path}/questions/#{question.id}/answers",
                 params: {
                   access_token: access_token.token, answer: valid_params
                 },
                 headers: headers
          end.to change(question.answers, :count).by 1
        end

        context 'After the action is called' do
          before do
            post "#{api_path}/questions/#{question.id}/answers",
                 params: {
                   access_token: access_token.token, answer: valid_params
                 },
                 headers: headers
          end

          it_behaves_like 'Successful response'
        end
      end

      context 'with invalid params' do
        let(:invalid_params) do
          attributes_for(:answer, :invalid, question: question)
        end

        it 'returns error response' do
          post "#{api_path}/questions/#{question.id}/answers",
               params: {
                 access_token: access_token.token, answer: invalid_params
               },
               headers: headers

          expect(response).to have_http_status(400)
        end

        it 'does not create a new answer' do
          expect do
            post "#{api_path}/questions/#{question.id}/answers",
                 params: {
                   access_token: access_token.token, answer: invalid_params
                 },
                 headers: headers
          end.to_not change(question.answers, :count)
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let!(:answer) { create(:answer) }
    let(:valid_params) { { body: "New Body" } }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
      let(:path) { "#{api_path}/answers/#{answer.id}" }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      context 'on owned answer' do
        let!(:answer) do
          create(:answer, user_id: access_token.resource_owner_id)
        end

        context 'with valid params' do
          it 'updates the answer' do
            expect do
              patch "#{api_path}/answers/#{answer.id}",
                    params: {
                      access_token: access_token.token, answer: valid_params
                    },
                    headers: headers
            end.to change { answer.reload.body }.to "New Body"
          end

          context 'After the action is called' do
            before do
              patch "#{api_path}/answers/#{answer.id}",
                    params: {
                      access_token: access_token.token, answer: valid_params
                    },
                    headers: headers
            end

            it_behaves_like 'Successful response'
          end
        end

        context 'with invalid params' do
          let(:invalid_params) { { body: "" } }

          it 'returns error response' do
            patch "#{api_path}/answers/#{answer.id}",
                  params: {
                    access_token: access_token.token, answer: invalid_params
                  },
                  headers: headers

            expect(response).to have_http_status(400)
          end

          it 'does not update the answer' do
            expect do
              patch "#{api_path}/answers/#{answer.id}",
                    params: {
                      access_token: access_token.token, answer: invalid_params
                    },
                    headers: headers
            end.to_not change { answer.reload.body }
          end
        end
      end

      context 'on unowned answer' do
        it 'returns forbidden response' do
          patch "#{api_path}/answers/#{answer.id}",
                params: {
                  access_token: access_token.token, answer: valid_params
                },
                headers: headers

          expect(response).to have_http_status(403)
        end

        it 'does not update the answer' do
          expect do
            patch "#{api_path}/answers/#{answer.id}",
                  params: {
                    access_token: access_token.token, answer: valid_params
                  },
                  headers: headers
          end.to_not change { answer.reload.body }
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let!(:answer) { create(:answer) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
      let(:path) { "#{api_path}/answers/#{answer.id}" }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      context 'on owned answer' do
        let!(:answer) do
          create(:answer, user_id: access_token.resource_owner_id)
        end

        it 'deletes the answer' do
          expect do
            delete "#{api_path}/answers/#{answer.id}",
                   params: { access_token: access_token.token, id: answer },
                   headers: headers
          end.to change(Answer, :count).by(-1)
        end

        context 'After the action is called' do
          before do
            delete "#{api_path}/answers/#{answer.id}",
                   params: { access_token: access_token.token, id: answer },
                   headers: headers
          end

          it_behaves_like 'Successful response'
        end
      end

      context 'on unowned answer' do
        it 'returns forbidden response' do
          delete "#{api_path}/answers/#{answer.id}",
                 params: { access_token: access_token.token, id: answer },
                 headers: headers

          expect(response).to have_http_status(403)
        end

        it 'does not delete the answer' do
          expect do
            delete "#{api_path}/answers/#{answer.id}",
                   params: { access_token: access_token.token, id: answer },
                   headers: headers
          end.to_not change(Answer, :count)
        end
      end
    end
  end
end
