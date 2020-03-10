require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  let(:service) { double('SearchService') }

  before { allow(SearchService).to receive(:new).and_return(service) }

  it 'calls SearchService#new with permitted params' do
    allow(service).to receive(:call)
    expect(SearchService).to receive(:new)
      .with({ query: 'ruby' }.with_indifferent_access)
    get :result, params: { query: 'ruby' }
  end

  it 'calls SearchService#call' do
    expect(service).to receive(:call)
    get :result, params: { query: 'ruby' }
  end

  it 'renders the result template' do
    allow(service).to receive(:call)
    get :result, params: { query: 'ruby' }
    expect(response).to render_template :result
  end
end
