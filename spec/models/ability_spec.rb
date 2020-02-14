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

    %i[question answer].each do |resource|
      it { should_not be_able_to :update, create(resource, user: other_user) }
      it { should_not be_able_to :destroy, create(resource, user: other_user) }
      it { should be_able_to :update, create(resource, user: user) }
      it { should be_able_to :destroy, create(resource, user: user) }

      describe "votes" do
        it { should be_able_to :upvote, create(resource, user: other_user) }
        it { should_not be_able_to :upvote, create(resource, user: user) }
        it { should be_able_to :downvote, create(resource, user: other_user) }
        it { should_not be_able_to :downvote, create(resource, user: user) }
        it { should_not be_able_to :cancel, create(resource, user: other_user) }
        it { should_not be_able_to :cancel, create(resource, user: user) }

        context 'with a positive vote' do
          let(:upvoted) { create(resource) }
          let!(:vote) { create(:vote, user: user, votable: upvoted) }

          it { should_not be_able_to :upvote, upvoted }
          it { should be_able_to :downvote, upvoted }
          it { should be_able_to :cancel, upvoted }
        end

        context 'with a negative vote' do
          let(:downvoted) { create(resource) }
          let!(:vote) { create(:vote, :negative, user: user, votable: downvoted) }

          it { should be_able_to :upvote, downvoted }
          it { should_not be_able_to :downvote, downvoted }
          it { should be_able_to :cancel, downvoted }
        end
      end
    end

    describe 'with indirect ownership' do
      let(:owned_question) { create(:question, user: user) }
      let(:other_question) { create(:question, user: other_user) }

      describe 'of answers' do
        let(:answer_to_owned) { create(:answer, question: owned_question) }
        let(:answer_to_other) { create(:answer, question: other_question) }
        let(:best_answer) do
          create(:answer, best: true, question: owned_question)
        end

        it { should be_able_to :select, answer_to_owned }
        it { should_not be_able_to :select, best_answer }
        it { should_not be_able_to :select, answer_to_other }
      end

      describe 'of attachments' do
        before do
          owned_question.files.attach(create_file_blob)
          owned_question.files.attach(create_file_blob)
        end

        it { should be_able_to :destroy, owned_question.files.first }
        it { should_not be_able_to :destroy, other_question.files.first }
      end

      describe 'of links' do
        let(:owned_link) { create(:link, linkable: owned_question) }
        let(:other_link) { create(:link, linkable: other_question) }

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
