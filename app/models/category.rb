class Category < ApplicationRecord
  has_many :post_categories, dependent: :destroy
  has_many :posts, through: :post_categories

  validates :permalink, uniqueness: true,
  length: { maximum: 50 }

  def to_param
    permalink
  end

end
