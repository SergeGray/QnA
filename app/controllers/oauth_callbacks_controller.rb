class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    authenticate_with_oauth
  end

  def vkontakte
    authenticate_with_oauth
  end

  private

  def authenticate_with_oauth
    @user = FindForOauthService.new(auth_hash).call

    if @user&.persisted?
      skip_confirmation_and_sign_in
    elsif @user
      ask_to_complete_registration
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def skip_confirmation_and_sign_in
    @user.skip_confirmation!
    @user.save!
    sign_in_and_redirect @user, event: :authentication
    return unless is_navigational_format?

    set_flash_message(:notice, :success, kind: action_name.capitalize)
  end

  def ask_to_complete_registration
    session[:omniauth] = auth_hash
    flash[:alert] = 'Please complete registration. Password is optional.'
    redirect_to new_user_registration_path
  end

  def auth_hash
    request.env['omniauth.auth']
  end
end
