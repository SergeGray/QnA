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
      head 200
    else
      head 400
    end
  end

  def update
    if @question.update(question_params)
      head 200
    else
      head 400
    end
  end

  def destroy
    @question.destroy
  end

  private

  def set_question
    @question = Question.find(params[:id])
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
