class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.where(
      created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day
    )

    mail to: user.email
  end
end
