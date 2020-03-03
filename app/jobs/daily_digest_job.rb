class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform
    DailyDigestService.call
  end
end
