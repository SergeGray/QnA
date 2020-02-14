module VotableActions
  extend ActiveSupport::Concern

  included do
    before_action :set_resource, only: %i[upvote downvote cancel]
  end

  def upvote
    authorize! :upvote, @votable
    @votable.upvote!(current_user)
    render_json
  end

  def downvote
    authorize! :downvote, @votable
    @votable.downvote!(current_user)
    render_json
  end

  def cancel
    authorize! :cancel, @votable
    @votable.clear_votes!(current_user)
    render_json
  end

  private

  def set_resource
    @votable = votable_model.find(params[:id])
  end

  def render_json
    render json: {
      score: @votable.score,
      class_name: @votable.class.name.downcase,
      id: @votable.id
    }
  end

  def votable_model
    controller_name.classify.constantize
  end
end
