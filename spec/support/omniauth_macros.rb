module OmniauthMacros
  def mock_auth_hash(
    provider,
    uid: '12345',
    email: nil
  )
    OmniAuth.config.add_mock(
      provider, {
        provider: provider.to_s,
        uid: uid,
        info: { email: email }
      }
    )
  end
end
