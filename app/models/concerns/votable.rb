module Votable
  VALUES = { positive: true, negative: false }.freeze
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def score
    votes.positive.count - votes.negative.count
  end

  def upvote!(user)
    vote(user, :positive)
  end

  def downvote!(user)
    vote(user, :negative)
  end

  private

  def vote(user, value)
    transaction do
      votes.where(user: user).destroy_all
      votes.create!(user: user, positive: VALUES[value])
    end
  end
end
