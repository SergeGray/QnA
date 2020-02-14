class AnswersController < ApplicationController
  include VotableActions

  before_action :authenticate_user!
  before_action :set_question, only: :create
  before_action :set_answer, only: %i[edit update select destroy]

  authorize_resource

  after_action :publish_answer, only: :create

  def edit; end

  def create
    @answer = current_user.answers.create(
      answer_params.merge(question: @question)
    )
  end

  def update
    @answer.update(answer_params)
  end

  def select
    authorize! :select, @answer
    @answer.select_as_best!
    @question = @answer.question
  end

  def destroy
    @answer.destroy
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "questions/#{@answer.question_id}/answers",
      wardenized_renderer.render(
        partial: 'answers/answer',
        locals: { answer: @answer }
      )
    )
  end

  def answer_params
    params.require(:answer).permit(
      :body, files: [], links_attributes: %i[id name url _destroy]
    )
  end
end
