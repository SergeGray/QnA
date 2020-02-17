require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for admin' do
    let(:user) { build(:user, :admin) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { build(:user, id: 1) }
    let(:other_user) { build(:user, id: 2) }

    it { should be_able_to :read, :all }

    [Question, Answer, Comment].each do |resource_class|
      it { should be_able_to :create, resource_class }
    end

    %i[question answer].each do |resource|
      let(:owned_resource) { build(resource, user: user) }
      let(:other_resource) { build(resource, user: other_user) }

      it { should_not be_able_to :update, other_resource }
      it { should_not be_able_to :destroy, other_resource }
      it { should be_able_to :update, owned_resource }
      it { should be_able_to :destroy, owned_resource }
      it { should be_able_to :vote, other_resource }
      it { should_not be_able_to :vote, owned_resource }
    end

    describe 'indirect ownership' do
      let(:owned_question) { create(:question, user: user, id: 1) }
      let(:other_question) { create(:question, user: other_user, id: 2) }

      describe 'answers' do
        let(:answer_to_owned) { build(:answer, question: owned_question) }
        let(:answer_to_other) { build(:answer, question: other_question) }
        let(:best_answer) do
          build(:answer, best: true, question: owned_question)
        end

        it { should be_able_to :select, answer_to_owned }
        it { should_not be_able_to :select, best_answer }
        it { should_not be_able_to :select, answer_to_other }
      end

      describe 'attachments' do
        before do
          owned_question.files.attach(create_file_blob)
          owned_question.files.attach(create_file_blob)
        end

        it { should be_able_to :destroy, owned_question.files.first }
        it { should_not be_able_to :destroy, other_question.files.first }
      end

      describe 'links' do
        let(:owned_link) { build(:link, linkable: owned_question) }
        let(:other_link) { build(:link, linkable: other_question) }

        it { should be_able_to :destroy, owned_link }
        it { should_not be_able_to :destroy, other_link }
      end
    end

    it { should_not be_able_to :manage, :all }
  end

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, :all }

    it { should_not be_able_to :manage, :all }
  end
end
