require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:service) { double('DailyDigestService') }

  before { allow(DailyDigestService).to receive(:new).and_return(service) }

  it 'calls DailyDigestService#call' do
    expect(service).to receive(:call)
    DailyDigestJob.perform_now
  end
end
