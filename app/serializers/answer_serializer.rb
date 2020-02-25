class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at

  has_many :links
  has_many :comments
  has_many :files, serializer: AttachmentSerializer

  belongs_to :user
  belongs_to :question
end
