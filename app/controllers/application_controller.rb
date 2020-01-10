class ApplicationController < ActionController::Base
  def check_ownership(attribute, path)
    return if current_user == attribute.user

    redirect_to path,
                alert: "You can't change other people's #{attribute.class}!"
  end
end
