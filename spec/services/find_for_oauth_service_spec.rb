require 'rails_helper'

RSpec.describe FindForOauthService do
  let!(:user) { create(:user) }
  let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
  subject { FindForOauthService.new(auth) }

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
      expect(subject.call).to eq user
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
        expect { subject.call }.to_not change(User, :count)
      end

      it 'creates an authorization for user' do
        expect { subject.call }
          .to change(user.authorizations, :count).by 1
      end

      it 'gives the new authorization correct provider and uid' do
        user = subject.call
        authorization = user.authorizations.last

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end

      it 'returns correct user' do
        expect(subject.call).to eq user
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
        expect { subject.call }.to change(User, :count).by 1
      end

      it 'creates an authorization for the new user' do
        user = subject.call
        expect(user.authorizations).to_not be_empty
      end

      it 'gives the new authorization correct provider and uid' do
        authorization = subject.call.authorizations.last

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end

      it 'returns the new user' do
        expect(subject.call).to be_a User
      end

      it 'gives the new user the correct email' do
        user = subject.call
        expect(user.email).to eq auth.info[:email]
      end

      context 'provider does not supply email' do
        let(:auth) do
          OmniAuth::AuthHash.new(
            provider: 'facebook',
            uid: '123456',
            info: {}
          )
        end

        it 'returns an uninitialized user' do
          expect(subject.call).to be_a_new User
        end
      end
    end
  end
end
