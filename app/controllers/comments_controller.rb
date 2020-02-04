class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: :create

  after_action :publish_comment, only: :create

  def create
    @comment = current_user.comments.create(
      comment_params.merge(commentable: @commentable)
    )
  end

  private

  def set_commentable
    commentable_class = [Question, Answer].find do |commentable|
      params["#{commentable.name.downcase}_id"]
    end

    @commentable = commentable_class.find(
      params["#{commentable_class.name.downcase}_id"]
    )
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast(
      "questions/#{question_id}/comments",
      template: comment_template,
      commentable_type: @comment.commentable_type.downcase,
      commentable_id: @commentable.id
    )
  end

  def comment_template
    ApplicationController.render(
      partial: 'comments/comment',
      locals: { comment: @comment }
    )
  end


  def question_id
    @commentable.is_a?(Question) ? @commentable.id : @commentable.question_id
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
