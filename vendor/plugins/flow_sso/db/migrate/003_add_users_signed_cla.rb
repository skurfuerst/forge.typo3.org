class AddUsersSignedCla < ActiveRecord::Migration
  def self.up
    add_column :users, :signed_cla, :boolean
  end

  def self.down
    remove_column :users, :signed_cla
  end
end
