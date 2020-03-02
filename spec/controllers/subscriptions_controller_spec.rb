require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do

  describe "POST #create" do
    let(:question) { create(:question) }

    context 'Authenticated user' do
      let(:user) { create(:user) }
      
      before { login(user) }

      it 'creates a question subscription' do
        expect do
          post :create,
               params: { question_id: question.id },
               format: :js
        end.to change(question.subscriptions, :count).by 1
      end

      it 'creates a current_user subscription' do
        expect do
          post :create,
               params: { question_id: question.id },
               format: :js
        end.to change(user.subscriptions, :count).by 1
      end

      it 'renders the create template' do
        post :create, params: { question_id: question.id }, format: :js

        expect(response).to render_template :create
      end
    end

    context 'Unauthenticated user' do
      it 'does not create a subscription' do
        expect do
          post :create,
               params: { question_id: question.id },
               format: :js
        end.to_not change(Subscription, :count)
      end

      context 'after action is called' do
        before do
          post :create, params: { question_id: question.id }, format: :js
        end

        it_behaves_like 'malicious action'
      end
    end
  end

  describe "DELETE #destroy" do
    context 'Authenticated user' do
    end

    context 'Unauthenticated user' do
    end
  end
end
