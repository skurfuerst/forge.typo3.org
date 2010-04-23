class AddUsersProjectMovePermission < ActiveRecord::Migration
  def self.up
    add_column :users, :project_move_permission, :boolean
  end

  def self.down
    remove_column :users, :project_move_permission
  end
end
