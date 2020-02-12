class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  # check_authorization

  def check_ownership(attribute, path)
    return if current_user.author_of?(attribute)

    redirect_to path,
                alert: "You can't change other people's #{attribute.class}!"
  end

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
