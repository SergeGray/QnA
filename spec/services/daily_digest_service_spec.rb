require 'rails_helper'

RSpec.describe DailyDigestService do
  subject { DailyDigestService }

  let(:users) { create_list(:user, 2) }

  context 'with questions created yesterday' do
    let!(:questions) do
      create_list(:question, 2, created_at: Date.yesterday, user: users.first)
    end

    it 'sends daily digest to all users' do
      users.each do |user|
        expect(DailyDigestMailer)
          .to receive(:digest)
          .with(user)
          .and_call_original
      end

      subject.call
    end
  end

  context 'without questions created yesterday' do
    let!(:new_question) { create(:question) }
    let!(:old_question) { create(:question, created_at: 4.days.ago) }

    it 'does not send daily digest to anyone' do
      users.each do
        expect(DailyDigestMailer)
          .to_not receive(:digest)
      end

      subject.call
    end
  end
end
