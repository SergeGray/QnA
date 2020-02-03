require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:awards) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }

  describe '#author_of?' do
    let(:user) { build(:user, id: 1) }

    context 'when the user is owner of the resource' do
      let!(:question) { build(:question, user: user) }

      it 'returns true' do
        expect(user).to be_author_of(question)
      end
    end

    context 'when the user is not the owner of the resource' do
      let(:question) { build(:question) }

      it 'returns false' do
        expect(user).to_not be_author_of(question)
      end
    end
  end
end
