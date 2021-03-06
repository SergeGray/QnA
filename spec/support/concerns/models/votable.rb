require 'rails_helper'

RSpec.shared_examples_for Votable do
  it { should have_many(:votes).dependent(:destroy) }

  describe '#score' do
    let!(:vote1) { create(:vote, votable: resource) }
    let!(:vote2) { create(:vote, votable: resource) }
    let!(:vote3) { create(:vote, :negative, votable: resource) }

    it 'returns the difference between positive and negative votes' do
      expect(resource.score).to eq 1
    end
  end

  describe '#upvote!' do
    let(:user) { create(:user) }

    context 'with no vote from user' do
      it 'increases the score' do
        expect { resource.upvote!(user) }
          .to change(resource, :score).by 1
      end
    end

    context 'with an existing positive vote from user' do
      before { resource.upvote!(user) }

      it "doesn't change the score" do
        expect { resource.upvote!(user) }
          .to_not change(resource, :score)
      end
    end

    context 'with an existing negative vote from user' do
      before { resource.downvote!(user) }

      it 'changes the vote from negative to positive' do
        expect { resource.upvote!(user) }
          .to change(resource, :score).by 2
      end
    end
  end

  describe '#downvote!' do
    let(:user) { create(:user) }

    context 'with no vote from user' do
      it 'decreases the score' do
        expect { resource.downvote!(user) }
          .to change(resource, :score).by(-1)
      end
    end

    context 'with an existing negative vote from user' do
      before { resource.downvote!(user) }

      it "doesn't change the score" do
        expect { resource.downvote!(user) }
          .to_not change(resource, :score)
      end
    end

    context 'with an existing positive vote from user' do
      before { resource.upvote!(user) }

      it 'changes the vote from positive to negative' do
        expect { resource.downvote!(user) }
          .to change(resource, :score).by(-2)
      end
    end
  end

  describe '#clear_votes!' do
    let(:user) { create(:user) }

    context 'with no vote from user' do
      it 'does not change the score' do
        expect { resource.clear_votes!(user) }
          .to_not change(resource, :score)
      end
    end

    context 'with an existing negative vote from user' do
      before { resource.downvote!(user) }

      it 'removes the negative vote' do
        expect { resource.clear_votes!(user) }
          .to change(resource, :score).by 1
      end
    end

    context 'with an existing positive vote from user' do
      before { resource.upvote!(user) }

      it 'removes the positive vote' do
        expect { resource.clear_votes!(user) }
          .to change(resource, :score).by(-1)
      end
    end
  end

  describe '#vote_value' do
    let(:user) { create(:user) }

    it 'returns 0 with no vote from user' do
      expect(resource.vote_value(user)).to be 0
    end

    it 'returns 1 with a positive vote from user' do
      resource.upvote!(user)
      expect(resource.vote_value(user)).to eq 1
    end

    it 'returns -1 with a negative vote from user' do
      resource.downvote!(user)
      expect(resource.vote_value(user)).to eq(-1)
    end
  end
end
