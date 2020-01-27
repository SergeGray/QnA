require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }
  let(:answer) { create(:answer, user: user) }

  before { login(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer to database' do
        expect do
          post :create, params: {
            question_id: question.id,
            answer: attributes_for(:answer),
            format: :js
          }
        end.to change(question.answers, :count).by(1)
      end

      it 'assigns the new answer to current user' do
        expect do
          post :create, params: {
            question_id: question.id,
            answer: attributes_for(:answer),
            format: :js
          }
        end.to change(user.answers, :count).by(1)
      end

      it 'renders the create template again' do
        post :create, params: {
          question_id: question.id,
          answer: attributes_for(:answer),
          format: :js
        }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create, params: {
            question_id: question.id,
            answer: attributes_for(:answer, :invalid),
            format: :js
          }
        end.to_not change(Answer, :count)
      end

      it 'renders the create template again' do
        post :create, params: {
          question_id: question.id,
          answer: attributes_for(:answer, :invalid),
          format: :js
        }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    context "on someone else's answer" do
      let(:answer2) { create(:answer) }

      before do
        patch :update, params: {
          id: answer2,
          answer: attributes_for(:answer, :new),
          format: :js
        }
      end

      it "doesn't change answer attributes" do
        expect { answer.reload }.to_not change(answer2, :attributes)
      end

      it 'redirects to question' do
        expect(response).to redirect_to(answer2.question)
      end
    end

    context 'with valid attributes' do
      before do
        patch :update, params: {
          id: answer,
          answer: attributes_for(:answer, :new),
          format: :js
        }
      end

      it 'assigns the requested answer to @answer' do
        expect(assigns(:answer)).to eq(answer)
      end

      it 'changes answer attributes' do
        expect { answer.reload }
          .to change(answer, :body).to(attributes_for(:answer, :new)[:body])
      end

      it 'renders update view' do
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before do
        patch :update, params: {
          id: answer,
          answer: attributes_for(:answer, :invalid),
          format: :js
        }
      end

      it 'does not change the answer' do
        expect { answer.reload }.to_not change(answer, :attributes)
      end

      it 'renders update view' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'PATCH #select' do
    let!(:answer) { create(:answer, question: question) }

    context "on someone else's question" do
      it 'does not select answer as best' do
        patch :select, params: { id: answer, format: :js }
        expect { answer.reload }.to_not change(answer, :best)
      end
    end

    context "on user's own question" do
      let!(:question) { create(:question, user: user) }
      let!(:answer) { create(:answer, question: question) }
      let!(:answer2) { create(:answer, question: question, best: true) }

      before { patch :select, params: { id: answer, format: :js } }

      it 'selects the answer as best' do
        expect { answer.reload }.to change(answer, :best).to true
      end

      it 'unselects the previous best answer' do
        expect { answer2.reload }.to change(answer2, :best).to false
      end

      it 'renders the select template' do
        expect(response).to render_template :select
      end
    end
  end

  describe 'DELETE #destroy' do
    context "on someone else's answer" do
      let!(:answer) { create(:answer) }

      it 'does not delete the answer' do
        expect do
          delete :destroy, params: { id: answer, format: :js }
        end.to_not change(Answer, :count)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: answer, format: :js }
        expect(response).to redirect_to answer.question
      end
    end

    context "on user's own answer" do
      let!(:answer) { create(:answer, user: user) }

      it 'deletes the answer' do
        expect do
          delete :destroy, params: { id: answer, format: :js }
        end.to change(Answer, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: answer, format: :js }
        expect(response).to render_template :destroy
      end
    end
  end
end
