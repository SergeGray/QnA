class Question < ApplicationRecord
  include Commentable
  include Linkable
  include Votable

  belongs_to :user

  has_many :answers, dependent: :destroy

  has_one :award, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :award, reject_if: :all_blank

  validates :title, :body, presence: true
end
