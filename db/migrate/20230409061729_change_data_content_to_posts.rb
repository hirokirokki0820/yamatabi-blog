class ChangeDataContentToPosts < ActiveRecord::Migration[7.0]
  def change
    change_column :posts, :content, :text, :limit => 4294967295
  end
end
