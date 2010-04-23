class AddTopbarTextcolor < ActiveRecord::Migration
  def self.up
    add_column :projects, :topbartextcolor, :string
  end

  def self.down
    remove_column :projects, :topbartextcolor
  end
end
