require 'rails_helper'
require 'shared_controller_examples'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'DELETE #destroy' do

    before { question.files.attach(create_file_blob) }

    context 'when logged in' do
      before { sign_in(user) }

      context "on another user's question" do
        it 'does not delete the attachment' do
          expect do
            delete :destroy, params: { id: question.files.first, format: :js }
          end.to_not change(ActiveStorage::Attachment, :count)
        end

        it 'renders the destroy template' do
          delete :destroy, params: { id: question.files.first, format: :js }
          expect(response).to render_template(:destroy)
        end
      end

      context "on user's own question" do
        before { question.update!(user: user) }

        it 'deletes the attachment' do
          expect do
            delete :destroy, params: { id: question.files.first, format: :js }
          end.to change(question.files, :count).by(-1)
        end

        it 'renders the destroy template' do
          delete :destroy, params: { id: question.files.first, format: :js }
          expect(response).to render_template(:destroy)
        end
      end
    end

    context 'when not logged in' do
      before do
        delete :destroy, params: { id: question.files.first, format: :js } 
      end

      it_behaves_like 'malicious action'
    end
  end
end
