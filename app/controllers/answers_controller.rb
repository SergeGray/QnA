class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: :create
  before_action :set_answer, only: %i[edit update select destroy]
  before_action only: %i[edit update destroy] do
    check_ownership(@answer, question_path(@answer.question))
  end

  before_action only: :select do
    check_ownership(@answer.question, questions_path)
  end

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

  def answer_params
    params.require(:answer).permit(
      :body, files: [], links_attributes: %i[id name url _destroy]
    )
  end
end
