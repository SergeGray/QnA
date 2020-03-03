require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  it 'calls DailyDigestService#call' do
    expect(DailyDigestService).to receive(:call)
    DailyDigestJob.perform_now
  end
end
