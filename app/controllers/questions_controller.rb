class QuestionsController < ApplicationController
  include VotableActions

  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show edit update destroy]
  before_action only: %i[edit update destroy] do
    check_ownership(@question, questions_path)
  end

  after_action :publish_question, only: :create

  def index
    @questions = Question.all
  end

  def show
    gon.push(question_id: @question.id)
  end

  def new
    @question = current_user.questions.new
    @question.build_award
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
  end

  def destroy
    @question.destroy
    redirect_to questions_path,
                notice: 'Your question was successfully destroyed'
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      wardenized_renderer.render(
        partial: 'questions/question',
        locals: { question: @question }
      )
    )
  end

  def question_params
    params.require(:question).permit(
      :title,
      :body,
      files: [],
      links_attributes: %i[id name url _destroy],
      award_attributes: %i[title image]
    )
  end
end
