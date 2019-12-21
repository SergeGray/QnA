require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe 'GET #new' do
    before { get :new, params: { question_id: question.id } }

    it 'assigns a new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: answer } }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq(answer)
    end

    it 'renders edit view' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer to database' do
        expect do
          post :create, params: {
            question_id: question.id,
            answer: attributes_for(:answer)
          }
        end.to change(question.answers, :count).by(1)
      end

      it 'redirects to question' do
        post :create, params: {
          question_id: question.id,
          answer: attributes_for(:answer)
        }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create, params: {
            question_id: question.id,
            answer: attributes_for(:answer, :invalid)
          }
        end.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: {
          question_id: question.id,
          answer: attributes_for(:answer, :invalid)
        }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      before do
        patch :update, params: {
          id: answer,
          answer: attributes_for(:answer, :new)
        }
      end

      it 'assigns the requested answer to @answer' do
        expect(assigns(:answer)).to eq(answer)
      end

      it 'changes answer attributes' do
        expect { answer.reload }
          .to change(answer, :body).to(attributes_for(:answer, :new)[:body])
      end

      it 'redirects to question' do
        expect(response).to redirect_to(answer.question)
      end
    end
    context 'with invalid attributes' do
      before do
        patch :update, params: {
          id: answer,
          answer: attributes_for(:answer, :invalid)
        }
      end

      it 'does not change the question' do
        expect { answer.reload }.to_not change(answer, :attributes)
      end

      it 're-renders edit view' do
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer) }

    it 'deletes the answer' do
      expect do
        delete :destroy, params: { id: answer }
      end.to change(Answer, :count).by(-1)
    end

    it 'redirects to question' do
      delete :destroy, params: { id: answer }
      expect(response).to redirect_to answer.question
    end
  end
end
