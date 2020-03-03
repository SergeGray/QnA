require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it do
    should have_many(:subscribed_questions)
      .through(:subscriptions)
      .source(:question)
  end
  it { should have_many :awards }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#subscribed?' do
    let(:question) { create(:question) }
    let(:user) { create(:user) }

    it 'returns true when user is subscribed to question' do
      create(:subscription, user: user, question: question)

      expect(user).to be_subscribed(question)
    end

    it 'returns false when user is not subscribed to question' do
      expect(user).to_not be_subscribed(question)
    end
  end
end
