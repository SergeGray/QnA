class Api::V1::ProfilesController < Api::V1::BaseController
  authorize_resource

  def me
    render json: current_resource_owner
  end

  def index
    render json: User.where('id <> ?', current_resource_owner.id)
  end
end
