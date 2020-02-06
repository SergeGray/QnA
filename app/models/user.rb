class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :awards

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]

  def self.find_for_oauth(auth)
    authorization = Authorization.find_by(auth_params(auth))
    return authorization.user if authorization

    user = find_or_create(auth.info[:email])
    user.authorizations.create(auth_params(auth))
    user
  end

  def author_of?(resource)
    resource.user_id == id
  end

  private

  def self.find_or_create(email)
    password = Devise.friendly_token[0, 20]
    User.find_by(email: email) || User.create!(
      email: email,
      password: password,
      password_confirmation: password
    )
  end

  def self.auth_params(auth)
    { provider: auth.provider, uid: auth.uid.to_s }
  end
end
