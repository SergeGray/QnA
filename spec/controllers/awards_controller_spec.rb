require 'rails_helper'
require 'shared_controller_examples'

RSpec.describe AwardsController, type: :controller do
  let(:user) { create(:user) }
  let(:award) { create(:award, user: user) }

  describe 'GET #index' do
    context 'when logged in' do
      before do
        login(user)
        get :index
      end

      it "assigns @awards to be a collection of current user's awards" do
        expect(assigns(:awards)).to match_array(user.awards)
      end

      it 'renders index template' do
        expect(response).to render_template :index
      end
    end

    context 'when not logged in' do
      before { get :index }

      it_behaves_like 'unauthorized action'
    end
  end
end
