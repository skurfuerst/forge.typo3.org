class AddUsersImgHash < ActiveRecord::Migration
  def self.up
    add_column :users, :img_hash, :string
  end

  def self.down
    remove_column :users, :img_hash
  end
end
