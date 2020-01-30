module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def score
    votes.positive.count - votes.negative.count
  end

  def upvote!(user)
    vote(user, true)
  end

  def downvote!(user)
    vote(user, false)
  end

  def opinion(user)
    votes.find_by(user: user)&.positive?
  end

  private

  def vote(user, positive)
    transaction do
      votes.where(user: user).destroy_all
      votes.create!(user: user, positive: positive)
    end
  end
end
