require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for admin' do
    let(:user) { create(:user, :admin) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    it { should be_able_to :read, :all }
    
    [Question, Answer, Comment].each do |resource_class|
      it { should be_able_to :create, resource_class }
    end

    [:question, :answer].each do |resource|
      it { should_not be_able_to :update, create(resource, user: other_user) }
      it { should_not be_able_to :destroy, create(resource, user: other_user ) }
      it { should be_able_to :update, create(resource, user: user) }
      it { should be_able_to :destroy, create(resource, user: user) }
      it { should be_able_to :vote, create(resource, user: other_user) }
      it { should_not be_able_to :vote, create(resource, user: user) }
    end

    it { should_not be_able_to :manage, :all }
  end

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, :all }

    it { should_not be_able_to :manage, :all }
  end
end
