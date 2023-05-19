class Post < ApplicationRecord
  before_create :set_post_permalink
  belongs_to :user
  has_many :post_categories, dependent: :destroy
  has_many :categories, through: :post_categories

  validates :permalink, uniqueness: true,
  length: { maximum: 100 }
  enum status: { published: 1, draft: 0}

  def to_param
    permalink
  end

  private
    # 初期のパーマリンクを生成する（パーマリンクを指定しなかった場合)
    def set_post_permalink
      while self.permalink.blank? || Post.find_by(permalink: self.permalink).present? do
        self.permalink = "post-#{rand(99999999)}"
      end
    end

end
