class LongerProjectNames < ActiveRecord::Migration

  def self.up
    change_column :projects, :identifier, :string, :limit => 64
  end

  def self.down
    change_column :projects, :identifier, :string, :limit => 20
  end
end
