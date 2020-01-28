require 'rails_helper'

RSpec.describe AwardsController, type: :controller do
  let(:user) { create(:user) }
  let(:award) { create(:award, user: user) }

  before { login(user) }

  describe 'GET #index' do
    before { get :index }

    it "assigns @awards to be a collection of current user's awards" do
      expect(assigns(:awards)).to match_array(user.awards)
    end

    it 'renders index template' do
      expect(response).to render_template :index
    end
  end
end
