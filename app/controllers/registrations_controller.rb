class RegistrationsController < Devise::RegistrationsController
  def create
    super do |user|
      if user.persisted?
        if session[:omniauth]
          user.authorizations.create!(auth_params)
        else
          user.skip_confirmation!
          user.save!
        end
      end
    end
  end

  private

  def build_resource(*args)
    super

    return unless session[:omniauth]

    password = Devise.friendly_token[0, 20]
    @user.password = password if @user.password.blank?
    @user.password_confirmation = password if @user.password_confirmation.blank?
  end

  def auth_params
    {
      provider: session[:omniauth]['provider'],
      uid: session[:omniauth]['uid'].to_s
    }
  end
end
