module VotableActions
  extend ActiveSupport::Concern

  included do
    before_action :set_resource, only: %i[upvote downvote cancel]
    before_action :deny_owner, only: %i[upvote downvote cancel]

    skip_authorize_resource
  end

  def upvote
    authorize! :vote, @votable
    @votable.upvote!(current_user)
    render_json
  end

  def downvote
    authorize! :vote, @votable
    @votable.downvote!(current_user)
    render_json
  end

  def cancel
    authorize! :vote, @votable
    @votable.clear_votes!(current_user)
    render_json
  end

  private

  def deny_owner
    head 403 if current_user&.author_of?(@votable)
  end

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
