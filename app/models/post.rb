class Post < ApplicationRecord
  # extend Mobility

  # translates :title, type: :string
  # translates :description, type: :text

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

  scope :search_by_title, ->(query) {
    if query.present?
      sanitized_query = sanitize_sql_like(query)
      joins("INNER JOIN mobility_string_translations AS title_translations
            ON title_translations.translatable_id = posts.id
            AND title_translations.translatable_type = 'Post'
            AND title_translations.key = 'title'")
        .where("title_translations.value LIKE ?", "%#{sanitized_query}%")
        .distinct
    end
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
