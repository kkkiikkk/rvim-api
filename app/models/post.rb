class Post < ApplicationRecord
  has_and_belongs_to_many :categories

  has_one_attached :cover_image
  has_one_attached :video

  validates :title, :description, presence: true
  validate :video_format_validation

  after_commit :enqueue_transcoding, on: :create

  scope :newest, -> { order(year: :desc) }
  scope :filter_by_year, ->(year) { where(year:) }

  scope :search_by_title, ->(query) {
    return unless query.present?

    sanitized_query = sanitize_sql_like(query)
    joins("INNER JOIN mobility_string_translations AS title_translations
           ON title_translations.translatable_id = posts.id
           AND title_translations.translatable_type = 'Post'
           AND title_translations.key = 'title'")
      .where("title_translations.value LIKE ?", "%#{sanitized_query}%")
      .distinct
  }

  scope :filter_by_category, ->(category_id) {
    joins(:categories).where(categories: { id: category_id })
  }

  def hls_url
    return unless File.exist?(m3u8_path)

    "/videos/#{id}/stream.m3u8"
  end

  def m3u8_path
    Rails.root.join("public/videos/#{id}/stream.m3u8")
  end

  private

  def video_format_validation
    return unless video.attached? && video.blob.content_type != "video/mp4"

    errors.add(:video, "must be an MP4 file")
  end

  def enqueue_transcoding
    TranscodeVideoJob.perform_later(self)
  end
end
