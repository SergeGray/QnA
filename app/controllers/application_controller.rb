class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    if doorkeeper_token
      head 403
    else
      redirect_to root_url, alert: exception.message
    end
  end

  check_authorization unless: :devise_controller?

  private

  def wardenized_renderer
    renderer = ApplicationController.renderer.new
    renderer.instance_variable_set(
      :@env,
      "HTTP_HOST" => "localhost:3000",
      "HTTPS" => "off",
      "REQUEST_METHOD" => "GET",
      "SCRIPT_NAME" => "",
      "warden" => warden
    )

    renderer
  end
end
