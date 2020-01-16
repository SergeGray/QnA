class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: :create
  before_action :set_answer, only: %i[edit update destroy]
  before_action only: %i[edit update destroy] do
    check_ownership(@answer, question_path(@answer.question))
  end

  def edit; end

  def create
    @answer = current_user.answers.new(answer_params.merge(question: @question))

    if @answer.save
      redirect_to @question, notice: 'Your answer was successfully created.'
    else
      render 'questions/show'
    end
  end

  def update
    if @answer.update(answer_params)
      redirect_to @answer.question
    else
      render :edit
    end
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
