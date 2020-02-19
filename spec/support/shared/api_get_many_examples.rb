RSpec.shared_examples_for 'API get many' do
  let(:resource) { resource_list.first }
  let(:resource_response) do
    resource_json.find { |entry| entry['id'] == resource.id }
  end

  it 'returns a list of resources' do
    expect(resource_json.size).to eq resource_list.size
  end

  it 'returns all public fields' do
    public_fields.each do |attr|
      expect(resource_response[attr]).to eq resource.send(attr).as_json
    end
  end

  it 'does not return private fields' do
    private_fields.each do |attr|
      expect(resource_response).to_not have_key(attr)
    end
  end
end
