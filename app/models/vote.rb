class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  scope :positive, -> { where(positive: true) }
  scope :negative, -> { where(positive: false) }
end
