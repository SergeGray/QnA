class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: :create
  before_action :set_answer, only: %i[edit update destroy]
  before_action only: %i[edit update destroy] do
    check_ownership(@answer, question_path(@answer.question))
  end

  def edit; end

  def create
    @answer = current_user.answers.create(
      answer_params.merge(question: @question)
    )
    flash[:notice] = 'Your answer was successfully created.'
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
    flash[:notice] = 'Your answer was successfully updated.'
  end

  def destroy
    @answer.destroy
    redirect_to @answer.question,
                notice: 'Your answer was successfully destroyed'
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
