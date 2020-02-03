require 'rails_helper'
require 'shared/controller_examples'

RSpec.describe CommentsController, type: :controller do
  let(:question) { create(:question) }
  let(:comment) { create(:comment) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    context 'Authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new comment to database' do
          expect do
            post :create, params: {
              question_id: question.id,
              comment: attributes_for(:answer),
              format: :js
            }
          end.to change(question.comments, :count).by(1)
        end

        it 'assigns the new comment to current user' do
          expect do
            post :create, params: {
              question_id: question.id,
              comment: attributes_for(:comment),
              format: :js
            }
          end.to change(user.comments, :count).by(1)
        end

        it 'renders the create template again' do
          post :create, params: {
            question_id: question.id,
            comment: attributes_for(:comment),
            format: :js
          }
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'does not save the comment' do
          expect do
            post :create, params: {
              question_id: question.id,
              comment: attributes_for(:comment, :invalid),
              format: :js
            }
          end.to_not change(Comment, :count)
        end

        it 'renders the create template again' do
          post :create, params: {
            question_id: question.id,
            comment: attributes_for(:comment, :invalid),
            format: :js
          }
          expect(response).to render_template :create
        end
      end
    end

    describe 'Unauthenticated user' do
      it 'does not save the comment' do
        expect do
          post :create, params: {
            question_id: question.id,
            comment: attributes_for(:comment, :invalid),
            format: :js
          }
        end.to_not change(Comment, :count)
      end

      context 'after action is called' do
        before do
          post :create, params: {
            question_id: question.id,
            comment: attributes_for(:comment, :invalid),
            format: :js
          }
        end

        it_behaves_like 'malicious action'
      end
    end
  end
end
