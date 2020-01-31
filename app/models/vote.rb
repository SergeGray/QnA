class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value, presence: true

  scope :positive, -> { where('value > 0') }
  scope :negative, -> { where('value < 0') }
end
