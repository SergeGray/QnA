require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:body) }

  describe '.persisted' do
    let(:question) { create(:question) }
    let!(:answer1) { create(:answer, question: question) }

    it 'returns persisted answers' do
      question.answers.new(attributes_for(:answer, :new))

      expect(question.answers.persisted).to contain_exactly(answer1)
    end
  end
end
