class SubscriptionService
  def initialize(answer)
    @answer = answer
  end

  def call
    @answer.question.subscriptions.find_each do |subscription|
      SubscriptionMailer.notify(subscription.user, @answer).deliver_later
    end
  end
end
