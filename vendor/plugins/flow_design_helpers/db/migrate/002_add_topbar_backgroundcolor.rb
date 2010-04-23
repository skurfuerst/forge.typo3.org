class AddTopbarBackgroundcolor < ActiveRecord::Migration
  def self.up
    add_column :projects, :topbarbackgroundcolor, :string
  end

  def self.down
    remove_column :projects, :topbarbackgroundcolor
  end
end
