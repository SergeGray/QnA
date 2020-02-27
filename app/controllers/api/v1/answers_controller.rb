class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question, only: %i[index create]
  before_action :set_answer, only: %i[show update destroy]

  authorize_resource

  def index
    render json: @question.answers
  end

  def show
    render json: @answer
  end

  def create
    @answer = current_resource_owner.answers.new(
      answer_params.merge(question: @question)
    )
    if @answer.save
      render json: @answer, status: :created
    else
      render json: { answer: { errors: @answer.errors } },
             status: :unprocessable_entity
    end
  end

  def update
    if @answer.update(answer_params)
      render json: @answer
    else
      render json: { answer: { errors: @answer.errors } },
             status: :unprocessable_entity
    end
  end

  def destroy
    render json: @answer.destroy
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(
      :body, links_attributes: %i[id name url _destroy]
    )
  end
end
