class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: %i[show update destroy]

  authorize_resource

  def index
    render json: Question.all
  end

  def show
    render json: @question
  end

  def create
    @question = current_resource_owner.questions.new(question_params)
    if @question.save
      render json: @question, status: :created
    else
      render json: { question: { errors: @question.errors } },
             status: :unprocessable_entity
    end
  end

  def update
    if @question.update(question_params)
      render json: @question
    else
      render json: { question: { errors: @question.errors } },
             status: :unprocessable_entity
    end
  end

  def destroy
    render json: @question.destroy
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(
      :title,
      :body,
      links_attributes: %i[id name url _destroy],
      award_attributes: %i[title image]
    )
  end
end
