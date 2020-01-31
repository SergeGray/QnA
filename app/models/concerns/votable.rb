module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def score
    votes.sum(:value)
  end

  def upvote!(user)
    vote(user, 1)
  end

  def downvote!(user)
    vote(user, -1)
  end

  def clear_votes!(user)
    votes.where(user: user).destroy_all
  end

  def vote_value(user)
    votes.find_by(user: user)&.value || 0
  end

  private

  def vote(user, value)
    transaction do
      clear_votes!(user)
      votes.create!(user: user, value: value)
    end
  end
end
