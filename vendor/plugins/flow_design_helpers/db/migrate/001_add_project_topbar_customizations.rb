class AddProjectTopbarCustomizations < ActiveRecord::Migration
  def self.up
    add_column :projects, :quicklinks, :text
  end

  def self.down
    remove_column :projects, :quicklinks
  end
end
