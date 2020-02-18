class Api::V1::QuestionsController < Api::V1::BaseController
  def index
    render json: Question.all
  end
end
