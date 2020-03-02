class SubscriptionMailer < ApplicationMailer
  def notify(user, answer)
    @answer = answer

    mail to: user.email
  end
end
