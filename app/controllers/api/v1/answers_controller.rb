class Api::V1::AnswersController < Api::V1::BaseController
  def index
    @question = Question.find(params[:question_id])
    render json: @question.answers
  end

  def show
    render json: Answer.find(params[:id])
  end
end
