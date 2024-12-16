class Post < ApplicationRecord
  extend Mobility

  translates :title, type: :string
  translates :description, type: :text

  has_and_belongs_to_many :categories

  has_one_attached :cover_image
  has_one_attached :video

  validates :title, presence: true
  validates :description, presence: true

  validate :video_format_validation

  scope :newest, -> {
    order(year: :desc)
  }

  scope :filter_by_year, ->(year) {
    where(year:)
  }

  scope :seach_by_title, ->(title) {
    where("title LIKE ?", "%#{sanitize_sql_like(title)}%")
  }

  scope :filter_by_category, ->(category_id) {
    joins(:categories).where(categories: { id: category_id })
  }

  private

  def video_format_validation
    return unless video.attached?

    if video.blob.content_type != "video/mp4"
      errors.add(:video, "must be an MP4 file")
    end
  end
end
