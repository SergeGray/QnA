class Award < ApplicationRecord
  belongs_to :question
  belongs_to :user, optional: true

  has_one_attached :image

  validates :title, :image, presence: true
end
