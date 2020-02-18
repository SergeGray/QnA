require 'rails_helper'

describe 'Questions API', type: :request do
  let(:api_path) { '/api/v1/questions' }

  describe 'GET index' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:path) { "#{api_path}" }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let!(:answers) { create_list(:answer, 3, question: question) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }

      before do
        get "#{api_path}",
            params: { access_token: access_token.token },
            headers: headers
      end

      it 'returns a list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains a short title' do
        expect(question_response['short_title'])
          .to eq question.title.truncate(20)
      end

      describe 'answer' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns a list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all answer public fields' do
          %w[id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end
end
