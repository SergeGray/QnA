class AwardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @awards = current_user.awards
  end
end
