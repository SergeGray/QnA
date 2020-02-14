module VotableActions
  extend ActiveSupport::Concern

  included do
    before_action only: %i[upvote downvote cancel] do
      set_resource
      authorize_vote!
    end

    skip_authorize_resource only: %i[upvote downvote cancel]
    skip_authorization_check only: %i[upvote downvote cancel]
  end

  def upvote
    @votable.upvote!(current_user)
    render_json
  end

  def downvote
    @votable.downvote!(current_user)
    render_json
  end

  def cancel
    @votable.clear_votes!(current_user)
    render_json
  end

  private

  def authorize_vote!
    authorize! :vote, @votable
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
