module VotableActions
  extend ActiveSupport::Concern

  included do
    before_action :set_resource, only: %i[upvote downvote]
    before_action :deny_owner, only: %i[upvote downvote]
  end

  def upvote
    @votable.upvote!(current_user)
    render json: { score: @votable.score }
  end

  def downvote
    @votable.downvote!(current_user)
    render json: { score: @votable.score }
  end

  private

  def deny_owner
    head 403 if current_user&.author_of?(@votable)
  end

  def set_resource
    @votable = votable_model.find(params[:id])
  end

  def votable_model
    controller_name.classify.constantize
  end
end
