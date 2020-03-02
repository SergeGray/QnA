class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    @subscription = @question.subscriptions.create(user: current_user)
  end

  def destroy
    @subscription = Subscription.find(params[:id]).destroy
  end
end
