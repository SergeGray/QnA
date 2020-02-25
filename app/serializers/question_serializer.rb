class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at

  has_many :answers, serializer: AnswersSerializer
  has_many :links
  has_many :comments
  has_many :files, serializer: AttachmentSerializer

  belongs_to :user
end
