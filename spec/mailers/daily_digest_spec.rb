require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe '#digest' do
    let(:mail) { DailyDigestMailer.digest(user) }
    let(:user) { create(:user) }
    let(:new_questions) { create_list(:question, 2) }
    let(:yesterday_questions) { create_list(:question, 2, created_at: Time.zone.now - 1.day) }
    let(:old_questions) do
      create_list(:question, 2, created_at: Time.zone.now - 2.days)
    end

    it 'emails yesterday questions' do
      yesterday_questions.each do |question|
        expect(mail.body.encoded).to have_content(question.title)
      end
    end

    it 'does not email new questions' do
      new_questions.each do |question|
        expect(mail.body.encoded).to_not have_content(question.title)
      end
    end


    it 'does not email old questions' do
      old_questions.each do |question|
        expect(mail.body.encoded).to_not have_content(question.title)
      end
    end
  end
end
