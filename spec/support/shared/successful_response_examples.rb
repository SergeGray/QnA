RSpec.shared_examples_for 'Successful response' do
  it 'returns a successful response' do
    expect(response).to be_successful
  end
end
