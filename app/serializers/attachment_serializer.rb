class AttachmentSerializer < ActiveModel::Serializer
  attributes :url, :filename

  def url
    object.file.url
  end

  def filename
    object.file.filename
  end
end
