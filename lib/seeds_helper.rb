# frozen_string_literal: true

module SeedsHelper
  class << self
    def create_post!(video_path, image_path, attributes)
      post = Post.new(**attributes)

      post.cover_image.attach(
        io: File.open(image_path),
        filename: File.basename(image_path),
        content_type: "image/jpeg"
      )
      post.video.attach(
        io: File.open(video_path),
        filename: File.basename(video_path),
        content_type: "video/mp4"
      )

      post.save!
    end

    def create_category!(attributes = {})
      category = Category.new(**attributes)

      category.save!
    end
  end
end
