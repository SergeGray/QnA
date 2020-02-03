class AnswersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "questions/#{params[:question_id]}/answers"
  end
end
