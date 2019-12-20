require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }

  it "destroys dependent answers" do
    question = FactoryBot.create(:question)
    answer = FactoryBot.create(:answer)
    question.answers << answer

    expect { question.destroy }.to change { Answer.count }.by(-1)
  end
end
