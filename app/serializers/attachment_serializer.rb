class AttachmentSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :filename, :url

  def filename
    object.filename.to_s
  end

  def url
    rails_blob_path(object, only_path: true)
  end
end
