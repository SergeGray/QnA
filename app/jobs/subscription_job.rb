class SubscriptionJob < ApplicationJob
  queue_as :default

  def perform(answer)
    SubscriptionService.new(answer).call
  end
end
