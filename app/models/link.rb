class Link < ApplicationRecord
  GIST_URL = /^(https?:\/\/)?(www\.)?gist\.github\.com\/\w+\/\w+$/.freeze

  belongs_to :linkable, polymorphic: true, touch: true

  validates :name, :url, presence: true
  validates :url, format: URI.regexp(%w[http https])

  def gist?
    url.match(GIST_URL).present?
  end
end
