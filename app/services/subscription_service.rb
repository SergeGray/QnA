class SubscriptionService
  def initialize(answer)
    @answer = answer
  end

  def call
    @answer.question.subscribers.find_each do |user|
      SubscriptionMailer.notify(user, @answer).deliver_later
    end
  end
end
