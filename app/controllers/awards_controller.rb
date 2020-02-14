class AwardsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def index
    @awards = current_user.awards
  end
end
