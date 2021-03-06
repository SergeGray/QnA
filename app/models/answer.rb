class Answer < ApplicationRecord
  include Commentable
  include Linkable
  include Votable

  default_scope -> { order('best DESC, created_at') }

  belongs_to :question, touch: true
  belongs_to :user

  has_many_attached :files

  validates :body, presence: true
  validates :best, uniqueness: { scope: :question_id, best: true }, if: :best

  after_create_commit :after_create_commit_notify_subscribed

  scope :best, -> { where(best: true) }

  def select_as_best!
    transaction do
      question.answers.best.update_all(best: false)
      question.award&.update!(user: user)
      update!(best: true)
    end
  end

  private

  def after_create_commit_notify_subscribed
    NewAnswerNotificationJob.perform_later(self)
  end
end
