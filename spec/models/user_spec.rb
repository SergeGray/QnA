require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many :awards }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'user already has an authorization' do
      let!(:authorization) do
        create(
          :authorization,
          user: user,
          provider: 'facebook',
          uid: '123456'
        )
      end

      it 'returns the user' do
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has no authorization' do
      context 'user exists' do
        let(:auth) do
          OmniAuth::AuthHash.new(
            provider: 'facebook',
            uid: '123456',
            info: { email: user.email }
          )
        end

        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates an authorization for user' do
          expect { User.find_for_oauth(auth) }
            .to change(user.authorizations, :count).by 1
        end

        it 'gives the new authorization correct provider and uid' do
          user = User.find_for_oauth(auth)
          authorization = user.authorizations.last

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns correct user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) do
          OmniAuth::AuthHash.new(
            provider: 'facebook',
            uid: '123456',
            info: { email: 'new_user@example.com' }
          )
        end

        it 'creates a new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by 1
        end

        it 'creates an authorization for the new user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'gives the new authorization correct provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.last

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the new user' do
          expect(User.find_for_oauth(auth)).to be_a User
        end

        it 'gives the new user the correct email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info[:email]
        end
      end
    end
  end

  describe '#author_of?' do
    let(:user) { build(:user, id: 1) }

    context 'when the user is the owner of the resource' do
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
