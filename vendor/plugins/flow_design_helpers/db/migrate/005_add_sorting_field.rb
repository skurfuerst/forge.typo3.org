class AddSortingField < ActiveRecord::Migration
  def self.up
    add_column :projects, :sorting, :integer, :default => 0
  end

  def self.down
    remove_column :projects, :sorting
  end
end
