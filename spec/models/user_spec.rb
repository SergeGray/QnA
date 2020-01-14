require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }

  describe '#owner_of?' do
    let(:user) { create(:user) }

    context 'when the user is owner of the resource' do
      let!(:question) { create(:question, user: user) }

      it 'returns true' do
        expect(user.author_of?(question)).to be true
      end
    end

    context 'when the user is not the owner of the resource' do
      let(:question) { create(:question) }

      it 'returns false' do
        expect(user.author_of?(question)).to be false
      end
    end
  end
end
