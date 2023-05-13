class AddAvatarProfileToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :profile, :text
    add_column :users, :avatar, :integer
  end
end
