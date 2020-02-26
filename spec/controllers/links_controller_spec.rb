require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let!(:link) { create(:link, linkable: question) }

  describe 'DELETE #destroy' do
    describe 'Authenticated user' do
      before { login(user) }

      context "on another user's question" do
        it 'does not delete the link' do
          expect do
            delete :destroy, params: { id: link, format: :js }
          end.to_not change(Link, :count)
        end

        it 'redirects to root' do
          delete :destroy, params: { id: link, format: :js }
          expect(response).to redirect_to root_path
        end
      end

      context "on user's own question" do
        before { question.update!(user: user) }

        it 'deletes the link' do
          expect do
            delete :destroy, params: { id: link, format: :js }
          end.to change(question.links, :count).by(-1)
        end

        it 'renders the destroy template' do
          delete :destroy, params: { id: link, format: :js }
          expect(response).to render_template(:destroy)
        end
      end
    end

    describe 'Unauthenticated user' do
      it 'does not delete the link' do
        expect do
          delete :destroy, params: { id: link, format: :js }
        end.to_not change(Link, :count)
      end

      context 'after action is called' do
        before { delete :destroy, params: { id: link, format: :js } }

        it_behaves_like 'malicious action'
      end
    end
  end
end
