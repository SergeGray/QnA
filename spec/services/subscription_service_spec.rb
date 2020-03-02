require 'rails_helper'

RSpec.describe SubscriptionService do
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }
  let!(:users) { create_list(:user, 2) }
  let!(:unsubscribed_user) { create(:user) }
  subject { SubscriptionService.new(answer) }

  before { users.each { |user| user.subscriptions.create(question: question) } }

  it 'sends a notification to all subscribed users' do
    users.each do |user|
      expect(SubscriptionMailer)
        .to receive(:notify)
        .with(user, answer)
        .and_call_original
    end

    expect(SubscriptionMailer)
      .to receive(:notify)
      .with(question.user, answer)
      .and_call_original

    subject.call
  end

  it 'does not send notifications to unsubscribed users' do
    expect(SubscriptionMailer).to receive(:notify).thrice.and_call_original

    subject.call
  end
end
