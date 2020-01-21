class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show edit update destroy]
  before_action only: %i[edit update destroy] do
    check_ownership(@question, questions_path)
  end

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
  end

  def new
    @question = current_user.questions.new
  end

  def edit; end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question was successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params)

    flash[:notice] = 'Your question was successfully updated.'
  end

  def destroy
    @question.destroy
    redirect_to questions_path,
                notice: 'Your question was successfully destroyed'
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
