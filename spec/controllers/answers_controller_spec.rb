require 'rails_helper'
require 'shared/controller_examples'

RSpec.describe AnswersController, type: :controller do
  it_behaves_like VotableActions do
    let(:resource) { create(:answer) }
  end

  let(:question) { create(:question) }
  let(:user) { create(:user) }
  let(:answer) { create(:answer, user: user) }

  describe 'POST #create' do
    describe 'Authenticated user' do
      before { login(user) }

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

        it 'broadcasts the new answer' do
          expect do
            post :create, params: {
              question_id: question.id,
              answer: attributes_for(:answer),
              format: :js
            }
          end.to have_broadcasted_to("questions/#{question.id}/answers")
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

        it 'does not broadcast the new answer' do
          expect do
            post :create, params: {
              question_id: question.id,
              answer: attributes_for(:answer, :invalid),
              format: :js
            }
          end.to_not have_broadcasted_to("questions/#{question.id}/answers")
        end
      end
    end

    describe 'Unauthenticated user' do
      it 'does not save the answer' do
        expect do
          post :create, params: {
            question_id: question.id,
            answer: attributes_for(:answer, :invalid),
            format: :js
          }
        end.to_not change(Answer, :count)
      end

      context 'after action is called' do
        before do
          post :create, params: {
            question_id: question.id,
            answer: attributes_for(:answer, :invalid),
            format: :js
          }
        end

        it_behaves_like 'malicious action'
      end

      it 'does not broadcast the new answer' do
        expect do
          post :create, params: {
            question_id: question.id,
            answer: attributes_for(:answer, :invalid),
            format: :js
          }
        end.to_not have_broadcasted_to("questions/#{question.id}/answers")
      end
    end
  end

  describe 'PATCH #update' do
    describe 'Authenticated user' do
      before { login(user) }

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

        it 'redirects to root' do
          expect(response).to redirect_to root_path
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

    describe 'Unauthenticated user' do
      before do
        patch :update, params: {
          id: answer,
          answer: attributes_for(:answer, :new),
          format: :js
        }
      end

      it 'does not save the answer' do
        expect { answer.reload }.to_not change(answer, :attributes)
      end

      it_behaves_like 'malicious action'
    end
  end

  describe 'PATCH #select' do
    let!(:answer) { create(:answer, question: question) }

    describe 'Authenticated user' do
      before { login(user) }

      context "on someone else's question" do
        it 'does not select answer as best' do
          patch :select, params: { id: answer, format: :js }
          expect { answer.reload }.to_not change { answer.best? }
        end

        it 'redirects to root' do
          patch :select, params: { id: answer, format: :js }
          expect(response).to redirect_to root_path
        end
      end

      context "on user's own question" do
        let!(:question) { create(:question, user: user) }
        let!(:answer) { create(:answer, question: question) }
        let!(:answer2) { create(:answer, question: question, best: true) }

        before { patch :select, params: { id: answer, format: :js } }

        it 'selects the answer as best' do
          expect { answer.reload }
            .to change { answer.best? }
            .from(false)
            .to(true)
        end

        it 'unselects the previous best answer' do
          expect { answer2.reload }
            .to change { answer2.best? }
            .from(true)
            .to(false)
        end

        it 'renders the select template' do
          expect(response).to render_template :select
        end
      end
    end

    describe 'Unauthenticated user' do
      before { patch :select, params: { id: answer, format: :js } }

      it 'does not select the answer as best' do
        expect { answer.reload }.to_not change { answer.best? }
      end

      it_behaves_like 'malicious action'
    end
  end

  describe 'DELETE #destroy' do
    describe 'Authenticated user' do
      before { login(user) }

      context "on someone else's answer" do
        let!(:answer) { create(:answer) }

        it 'does not delete the answer' do
          expect do
            delete :destroy, params: { id: answer, format: :js }
          end.to_not change(Answer, :count)
        end

        it 'redirects to root' do
          delete :destroy, params: { id: answer, format: :js }
          expect(response).to redirect_to root_path
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

    describe 'Unauthenticated user' do
      let!(:answer) { create(:answer) }

      it 'does not delete the answer' do
        expect do
          delete :destroy, params: { id: answer, format: :js }
        end.to_not change(Answer, :count)
      end

      context 'after action is called' do
        before do
          delete :destroy, params: { id: answer, format: :js }
        end

        it_behaves_like 'malicious action'
      end
    end
  end
end
