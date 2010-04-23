class AddUsersSaltedPassword < ActiveRecord::Migration
  def self.up
    add_column :users, :salted_password, :string
  end

  def self.down
    remove_column :users, :salted_password
  end
end
