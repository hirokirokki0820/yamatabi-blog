class Post < ApplicationRecord
  belongs_to :user
  has_many :post_categories
  has_many :categories, through: :post_categories
  # validates :title, presence: true, length: { minimum: 1, maximum: 100 }
end
