module QuestionsHelper
  def destroy_link(question)
    return unless current_user == question.user

    link_to('Destroy', question_path(question), method: :delete)
  end
end
