require 'rails_helper'

RSpec.describe Answer, type: :model do
  let!(:user) { create(:user) }
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, user: user, question: question) }
  let!(:answer2) { create(:answer, :new, question: question, best: true) }

  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:body) }
  it { should validate_uniqueness_of(:best).scoped_to(:question_id) }

  describe '#select_as_best!' do

    it 'sets answer as best' do
      expect { answer.select_as_best! }.to change(answer, :best).to true
    end

    it 'unsets previous best answer' do
      answer.select_as_best!
      expect { answer2.reload }.to change(answer2, :best).to false
    end
  end

  it 'should put best answer first' do
    expect(question.answers).to match_array [answer2, answer]
  end
end
