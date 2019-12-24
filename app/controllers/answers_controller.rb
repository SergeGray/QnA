class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: :create
  before_action :set_answer, only: %i[edit update destroy]
  before_action :check_ownership, only: %i[edit update destroy]

  def edit; end

  def create
    @answer = @question.answers.new(answer_params)

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
    params
      .require(:answer)
      .permit(:body)
      .merge(user_id: current_user.id)
  end

  def check_ownership
    return if current_user == @answer.user

    redirect_to question_path(@answer.question),
                alert: "You can't change other people's answers!"
  end
end
