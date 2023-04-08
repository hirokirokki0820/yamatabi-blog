class RemoveDraftFromPosts < ActiveRecord::Migration[7.0]
  def change
    remove_column :posts, :draft, :boolean, default: false
  end
end
