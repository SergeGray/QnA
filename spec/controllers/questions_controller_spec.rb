require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
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

    it 'assigns a new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns a new link to be a @answer.link' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'renders show view' do
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it 'assigns a new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns a new link to be a @question.link' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'renders new view' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
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
    end
  end

  describe 'PATCH #update' do
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

  describe 'DELETE #destroy' do
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
end
