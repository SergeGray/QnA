require 'rails_helper'

RSpec.describe SubscriptionJob, type: :job do
  let(:service) { double('SubscriptionService') }
  let(:answer) { create(:answer) }

  before { allow(SubscriptionService).to receive(:new).and_return(service) }

  it 'calls SubscriptionService#call' do
    expect(service).to receive(:call)
    SubscriptionJob.perform_now(answer)
  end
end
