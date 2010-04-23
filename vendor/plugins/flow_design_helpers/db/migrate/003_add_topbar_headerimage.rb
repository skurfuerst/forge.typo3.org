# NOT NEEDED ANYMORE!!

class AddTopbarHeaderimage < ActiveRecord::Migration
  def self.up
    add_column :projects, :topbarheaderimage, :string
  end

  def self.down
    remove_column :projects, :topbarheaderimage
  end
end
