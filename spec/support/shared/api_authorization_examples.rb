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
