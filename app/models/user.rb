class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribed_questions, through: :subscriptions, source: :question
  has_many :awards

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: %i[github vkontakte]

  def subscribed?(question)
    subscriptions.exists?(question_id: question.id)
  end
end
