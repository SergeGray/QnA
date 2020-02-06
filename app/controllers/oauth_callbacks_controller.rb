class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = FindForOauthService.new(request.env['omniauth.auth']).call

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      if is_navigational_format?
        set_flash_message(:notice, :success, kind: 'Github')
      end
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
