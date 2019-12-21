class AnswersController < ApplicationController
  before_action :set_question, only: :new
  before_action :set_answer, only: :edit

  def new
    @answer = @question.answers.new
  end

  def edit; end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end
end
