class AddPermalinkToCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :permalink, :string
  end
end
