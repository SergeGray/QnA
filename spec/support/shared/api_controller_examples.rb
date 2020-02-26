RSpec.shared_examples_for 'API Authorizable' do
  it 'returns 401 status of there is no access_token' do
    do_request(method, path, headers: headers)
    expect(response.status).to eq 401
  end

  it 'returns 401 status if access_token is invalid' do
    do_request(
      method, path, params: { access_token: '123' }, headers: headers
    )
    expect(response.status).to eq 401
  end
end

RSpec.shared_examples_for 'API get one' do
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
