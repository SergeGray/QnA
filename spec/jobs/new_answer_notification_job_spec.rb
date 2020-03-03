require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  let(:service) { double('SubscriptionService') }
  let(:answer) { create(:answer) }

  before { allow(SubscriptionService).to receive(:new).and_return(service) }

  it 'calls SubscriptionService#call' do
    expect(service).to receive(:call)
    NewAnswerNotificationJob.perform_now(answer)
  end
end
