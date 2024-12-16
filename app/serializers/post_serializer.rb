class PostSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :description, :year, :cover_image

  def cover_image
    object.cover_image.attached? ? Rails.application.routes.url_helpers.rails_blob_url(object.cover_image, only_path: true) : nil
  end
end
