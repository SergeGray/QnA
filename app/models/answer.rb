class Answer < ApplicationRecord
  default_scope -> { order('best DESC, created_at') }

  belongs_to :question
  belongs_to :user

  has_many :links, as: :linkable, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true
  validates :best, uniqueness: { scope: :question_id, best: true }, if: :best

  scope :best, -> { where(best: true) }

  def select_as_best!
    transaction do
      question.answers.best.update_all(best: false)
      update!(best: true)
    end
  end
end
