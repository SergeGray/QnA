RSpec.shared_examples 'unauthorized action' do
  it 'redirects to login page' do
    expect(response).to redirect_to new_user_session_path
  end
end

RSpec.shared_examples 'malicious action' do
  it 'returns unauthorized response' do
    expect(response).to have_http_status(401)
  end
end
