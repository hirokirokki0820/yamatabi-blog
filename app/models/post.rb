class Post < ApplicationRecord
  belongs_to :user
  has_many :post_categories, dependent: :destroy
  has_many :categories, through: :post_categories
  # validates :title, presence: true, length: { minimum: 1, maximum: 100 }
  validates :permalink, uniqueness: true,
  length: { maximum: 100 }
  enum status: { published: 1, draft: 0}
end
