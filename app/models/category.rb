class Category < ApplicationRecord
  extend Mobility

  translates :title, type: :string

  has_and_belongs_to_many :posts

  validates :title, presence: true, uniqueness: true
end
