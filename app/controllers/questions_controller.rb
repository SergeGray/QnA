class QuestionsController < ApplicationController
  before_action :set_question, only: %i[show edit]

  def index
    @questions = Question.all
  end

  def show; end

  def new
    @question = Question.new
  end

  def edit; end

  private

  def set_question
    @question = Question.find(params[:id])
  end
end
