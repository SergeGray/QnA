require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:votable) }

  it { should validate_presence_of(:value) }

  let!(:vote1) { create(:vote) }
  let!(:vote2) { create(:vote, :negative) }

  describe '.positive' do
    it 'returns positive votes' do
      expect(Vote.positive).to contain_exactly(vote1)
    end
  end

  describe '.negative' do
    it 'returns negative votes' do
      expect(Vote.negative).to contain_exactly(vote2)
    end
  end
end
