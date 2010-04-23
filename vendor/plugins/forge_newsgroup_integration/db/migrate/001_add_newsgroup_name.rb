class AddNewsgroupName < ActiveRecord::Migration
  def self.up
      add_column :projects, :newsgroup_name, :string
  end
	
  def self.down
      remove_column :projects, :newsgroup_name, :description
  end
end
		