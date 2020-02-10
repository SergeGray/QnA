class FindForOauthService
  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.find_by(auth_params)
    return authorization.user if authorization

    user = find_or_create
    user.authorizations.create(auth_params) if user.persisted?
    user
  end

  private

  def find_or_create
    password = Devise.friendly_token[0, 20]
    return User.new unless email

    User.find_by(email: email) || User.create!(
      email: email,
      password: password,
      password_confirmation: password
    )
  end

  def email
    @auth.info[:email]
  end

  def auth_params
    { provider: @auth.provider, uid: @auth.uid.to_s }
  end
end
