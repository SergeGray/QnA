class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform
    DailyDigestService.new.call
  end
end
