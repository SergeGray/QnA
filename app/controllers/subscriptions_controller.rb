class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: %i[create]

  authorize_resource
  
  def create
    @question.subscriptions.create(user: current_user)
  end

  def destroy; end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end
end
