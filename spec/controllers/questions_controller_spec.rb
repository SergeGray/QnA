require 'rails_helper'
require 'shared/controller_examples'

RSpec.describe QuestionsController, type: :controller do
  it_behaves_like VotableActions do
    let(:resource) { create(:question) }
  end

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq(question)
    end

    it 'renders show view' do
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    describe 'Authenticated user' do
      before do
        login(user)
        get :new
      end

      it 'assigns a new question to @question' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it 'assigns a new award to @question.award' do
        expect(assigns(:question).award).to be_a_new(Award)
      end

      it 'renders new view' do
        expect(response).to render_template(:new)
      end
    end

    describe 'Unauthenticated user' do
      before { get :new }

      it 'does not assign a new question to @ question' do
        expect(assigns(:question)).to_not be_a_new(Question)
      end

      it 'does not assign a new award to @question.award' do
        expect(assigns(:question)).to_not respond_to(:award)
      end

      it_behaves_like 'unauthorized action'
    end
  end

  describe 'POST #create' do
    describe 'Authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new question to database' do
          expect do
            post :create, params: { question: attributes_for(:question) }
          end.to change(Question, :count).by(1)
        end

        it 'redirects to show view' do
          post :create, params: { question: attributes_for(:question) }
          expect(response).to redirect_to assigns(:question)
        end

        it 'broadcasts the new question' do
          expect do
            post :create, params: {
              question: attributes_for(:question),
              format: :js
            }
          end.to have_broadcasted_to('questions')
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect do
            post :create, params: {
              question: attributes_for(:question, :invalid)
            }
          end.to_not change(Question, :count)
        end

        it 're-renders new view' do
          post :create, params: { question: attributes_for(:question, :invalid) }
          expect(response).to render_template(:new)
        end

        it 'does not broadcast the new question' do
          expect do
            post :create, params: {
              question: attributes_for(:question, :invalid),
              format: :js
            }
          end.to_not have_broadcasted_to('questions')
        end
      end
    end

    describe 'Unauthenticated user' do
      it 'does not save the question' do
        expect do
          post :create, params: {
            question: attributes_for(:question, :invalid),
            format: :js
          }
        end.to_not change(Question, :count)
      end

      context 'after action is called' do
        before do
          post :create, params: {
            question: attributes_for(:question, :invalid),
            format: :js
          }
        end

        it_behaves_like 'malicious action'
      end

      it 'does not broadcast the new question' do
        expect do
          post :create, params: {
            question: attributes_for(:question, :invalid),
            format: :js
          }
        end.to_not have_broadcasted_to('questions')
      end
    end
  end

  describe 'PATCH #update' do
    describe 'Authenticated user' do
      before { login(user) }

      context "on another user's question" do
        let(:user2) { create(:user) }
        let(:question2) { create(:question, user: user2) }

        before do
          patch :update, params: {
            id: question2,
            question: attributes_for(:question, :new),
            format: :js
          }
        end

        it 'does not change the question' do
          expect { question2.reload }.to_not change(question2, :attributes)
        end

        it 'redirects to index view' do
          expect(response).to redirect_to(questions_path)
        end
      end

      context 'with valid attributes' do
        before do
          patch :update, params: {
            id: question,
            question: attributes_for(:question, :new),
            format: :js
          }
        end

        it 'assigns the requested question to @question' do
          expect(assigns(:question)).to eq(question)
        end

        it 'changes question attributes' do
          expect { question.reload }
            .to change(question, :title).to(
              attributes_for(:question, :new)[:title]
            ).and change(question, :body).to(
              attributes_for(:question, :new)[:body]
            )
        end

        it 'renders the update template' do
          expect(response).to render_template(:update)
        end
      end

      context 'with invalid attributes' do
        before do
          patch :update, params: {
            id: question,
            question: attributes_for(:question, :invalid),
            format: :js
          }
        end

        it 'does not change the question' do
          expect { question.reload }.to_not change(question, :attributes)
        end

        it 'renders the update template' do
          expect(response).to render_template(:update)
        end
      end
    end

    describe 'Unauthenticated user' do
      before do
        patch :update, params: {
          id: question,
          question: attributes_for(:question, :new),
          format: :js
        }
      end

      it 'does not save the question' do
        expect { question.reload }.to_not change(question, :attributes)
      end

      it_behaves_like 'malicious action'
    end
  end

  describe 'DELETE #destroy' do
    describe 'Authenticated user' do
      before { login(user) }

      context "on another user's question" do
        let(:user2) { create(:user) }
        let!(:question2) { create(:question, user: user2) }

        it 'does not delete the question' do
          expect do
            delete :destroy, params: { id: question2 }
          end.to_not change(Question, :count)
        end

        it 'redirects to index view' do
          delete :destroy, params: { id: question2 }
          expect(response).to redirect_to(questions_path)
        end
      end

      context "on user's own question" do
        let!(:question) { create(:question, user: user) }

        it 'deletes the question' do
          expect do
            delete :destroy, params: { id: question }
          end.to change(Question, :count).by(-1)
        end

        it 'redirects to index view' do
          delete :destroy, params: { id: question }
          expect(response).to redirect_to questions_path
        end
      end
    end

    describe 'Unauthenticated user' do
      let!(:question) { create(:question) }

      it 'does not delete the question' do
        expect do
          delete :destroy, params: { id: question, format: :js }
        end.to_not change(Question, :count)
      end

      context 'after action is called' do
        before do
          delete :destroy, params: { id: question, format: :js }
        end

        it_behaves_like 'malicious action'
      end
    end
  end
end
