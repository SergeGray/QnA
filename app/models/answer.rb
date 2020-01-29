class Answer < ApplicationRecord
  include Linkable

  default_scope -> { order('best DESC, created_at') }

  belongs_to :question
  belongs_to :user

  has_many_attached :files

  validates :body, presence: true
  validates :best, uniqueness: { scope: :question_id, best: true }, if: :best

  scope :best, -> { where(best: true) }

  def select_as_best!
    transaction do
      question.answers.best.update_all(best: false)
      question.award&.update!(user: user)
      update!(best: true)
    end
  end
end
