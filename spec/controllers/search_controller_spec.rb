require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  before { allow(SearchService).to receive(:call) }

  it 'calls SearchService#call with permitted params' do
    expect(SearchService).to receive(:call).with(query: 'ruby')
    get :index, params: { query: 'ruby' }
  end

  it 'renders the result template' do
    get :index, params: { query: 'ruby' }
    expect(response).to render_template :index
  end
end
