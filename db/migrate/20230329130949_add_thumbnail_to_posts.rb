class AddThumbnailToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :thumbnail, :integer
  end
end
