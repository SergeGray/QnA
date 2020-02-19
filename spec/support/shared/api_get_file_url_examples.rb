RSpec.shared_examples_for 'API get file url' do
  let(:resource) { resource_list.first }
  let(:resource_response) do
    resource_json.find { |entry| entry['id'] == resource.id }
  end

  it 'returns file url' do
    expect(resource_response['url'])
      .to eq rails_blob_path(resource, only_path: true)
  end
end
